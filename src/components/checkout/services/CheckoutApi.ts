import gql from 'x-syntax';
import { BrickOrder, BrickOrderVariables } from '../../../graphql/BrickOrder';
import {
  CreateOrderInit,
  CreateOrderInitVariables,
} from '../../../graphql/CreateOrderInit';
import {
  CreateOrderWithItems,
  CreateOrderWithItemsVariables,
} from '../../../graphql/CreateOrderWithItems';
import {
  ExploratoryMetadata,
  ExploratoryMetadataVariables,
} from '../../../graphql/ExploratoryMetadata';
import {
  PrintJobExploratoryItemInput,
  ShippingAddressInput,
} from '../../../graphql/globalTypes';
import { CreateOrderInput } from '../../../graphql/globalTypes';
import { CreateOrderItemInput } from '../../../graphql/globalTypes';
import {
  SendOrderConfirmationEmail,
  SendOrderConfirmationEmailVariables,
} from '../../../graphql/SendOrderConfirmationEmail';
import Client from './Client';

export default class CheckoutApi {
  private client: Client;

  public constructor(endpoint?: string) {
    this.client = new Client(endpoint);
  }

  public async brickOrder(
    stateHistory: string[],
    orderId: string,
    orderPaymentId: string,
  ): Promise<void> {
    await this.client.mutate<BrickOrder, BrickOrderVariables>({
      mutation: BRICK_ORDER_MUTATION,
      variables: {
        input: {
          orderId,
          orderPaymentId,
          stateHistory,
          userAgent: navigator ? navigator.userAgent : undefined,
        },
      },
    });
  }

  public async createOrderInitialization(
    amountInCents: number,
  ): Promise<{ success: true; data: CreateOrderInit } | { success: false }> {
    return await this.client.mutate<CreateOrderInit, CreateOrderInitVariables>({
      mutation: CREATE_ORDER_INITIALIZATION_MUTATION,
      variables: { input: { amount: amountInCents } },
    });
  }

  public async getExploratoryMetadata(
    items: Array<PrintJobExploratoryItemInput>,
    address: ShippingAddressInput,
  ): Promise<
    | { status: `success`; data: ExploratoryMetadata }
    | { status: `shipping_not_possible` }
    | { status: `error` }
  > {
    const result = await this.client.mutate<
      ExploratoryMetadata,
      ExploratoryMetadataVariables
    >({
      mutation: PRINT_JOB_EXPLORATORY_METADATA_QUERY,
      variables: { input: { items, address } },
    });
    switch (result.success) {
      case true:
        return { status: `success`, data: result.data };
      case false:
        if (
          result.error.includes(`not possible`) ||
          result.error.includes(`noExploratoryMetadataRetrieved`)
        ) {
          return { status: `shipping_not_possible` };
        } else {
          return { status: `error` };
        }
    }
  }

  public async createOrder(
    orderInput: CreateOrderInput,
    itemInputs: Array<CreateOrderItemInput>,
    token: string,
  ): Promise<boolean> {
    const { success } = await this.client.mutate<
      CreateOrderWithItems,
      CreateOrderWithItemsVariables
    >({
      mutation: CREATE_ORDER_MUTATION,
      variables: { order: orderInput, items: itemInputs },
      token,
    });
    return success;
  }

  public async chargeCreditCard(
    charge: () => Promise<{ error?: Error }>,
  ): Promise<
    | { status: `success` }
    | { status: `user_actionable_error`; error: string }
    | { status: `error`; error: string }
  > {
    try {
      const response = await charge();
      if (response.error) {
        return { status: `user_actionable_error`, error: response.error.message };
      } else {
        return { status: `success` };
      }
    } catch (error) {
      return { status: `error`, error: String(error) };
    }
  }

  public async sendOrderConfirmationEmail(orderId: string): Promise<boolean> {
    try {
      const { success } = await this.client.mutate<
        SendOrderConfirmationEmail,
        SendOrderConfirmationEmailVariables
      >({
        mutation: SEND_ORDER_CONFIRMATION_EMAIL_MUTATION,
        variables: { id: orderId },
      });
      return success;
    } catch {
      return false;
    }
  }
}

const BRICK_ORDER_MUTATION = gql`
  mutation BrickOrder($input: BrickOrderInput!) {
    result: brickOrder(input: $input) {
      success
    }
  }
`;

const CREATE_ORDER_INITIALIZATION_MUTATION = gql`
  mutation CreateOrderInit($input: CreateOrderInitializationInput!) {
    data: createOrderInitialization(input: $input) {
      orderId
      orderPaymentId
      stripeClientSecret
      token: createOrderToken
    }
  }
`;

const PRINT_JOB_EXPLORATORY_METADATA_QUERY = gql`
  query ExploratoryMetadata($input: GetPrintJobExploratoryMetadataInput!) {
    data: getPrintJobExploratoryMetadata(input: $input) {
      shippingLevel
      shippingInCents
      taxesInCents
      feesInCents
      creditCardFeeOffsetInCents
    }
  }
`;

const CREATE_ORDER_MUTATION = gql`
  mutation CreateOrderWithItems(
    $order: CreateOrderInput!
    $items: [CreateOrderItemInput!]!
  ) {
    order: createOrderWithItems(order: $order, items: $items) {
      id
    }
  }
`;

const SEND_ORDER_CONFIRMATION_EMAIL_MUTATION = gql`
  mutation SendOrderConfirmationEmail($id: UUID!) {
    response: sendOrderConfirmationEmail(id: $id) {
      success
    }
  }
`;
