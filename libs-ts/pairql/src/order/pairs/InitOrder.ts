// auto-generated, do not edit

export namespace InitOrder {
  export type Input = number;

  export interface Output {
    orderId: UUID;
    orderPaymentId: string;
    stripeClientSecret: string;
    createOrderToken: UUID;
  }
}
