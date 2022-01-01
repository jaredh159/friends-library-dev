export type File = {
  path: string;
  source: string;
};

export type DbClientProps = Array<[name: string, numArgs: number]>;

export type GlobalTypes = {
  dbEnums: Record<string, string[]>;
  taggedTypes: Record<string, string>;
};
