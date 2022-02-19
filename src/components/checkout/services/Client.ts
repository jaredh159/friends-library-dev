export default class Client {
  public constructor(private endpoint = process.env.GATSBY_API_ENDPOINT ?? ``) {}

  public async query<Data, Variables>(input: {
    query: string;
    variables: Variables;
    token?: string;
  }): Promise<{ success: true; data: Data } | { success: false; error: string }> {
    const result = await this.fetch<Data, Variables>(
      input.query,
      input.variables,
      input.token,
    );
    if (result.success) {
      return result;
    } else {
      return {
        success: false,
        error: result.errors.map((err) => err.message).join(`,`),
      };
    }
  }

  public async mutate<Data, Variables>(input: {
    mutation: string;
    variables: Variables;
    token?: string;
  }): Promise<{ success: true; data: Data } | { success: false; error: string }> {
    return this.query({ ...input, query: input.mutation });
  }

  private async fetch<Data, Variables>(
    operation: string,
    variables: Variables,
    token?: string,
  ): Promise<
    { success: true; data: Data } | { success: false; errors: Array<{ message: string }> }
  > {
    try {
      const response = await window.fetch(this.endpoint, {
        method: `POST`,
        headers: {
          'Content-Type': `application/json`,
          ...(token ? { Authorization: `Bearer ${token}` } : {}),
        },
        body: JSON.stringify({
          query: operation,
          ...(variables ? { variables } : {}),
        }),
      });
      const json = await response.json();
      if (`data` in json && `errors` in json === false) {
        return { success: true, data: json.data };
      } else if (`errors` in json && Array.isArray(json.errors)) {
        return { success: false, errors: json.errors };
      } else {
        return { success: false, errors: [{ message: `Unexpected error` }] };
      }
    } catch (error) {
      return { success: false, errors: [{ message: `${error}` }] };
    }
  }
}
