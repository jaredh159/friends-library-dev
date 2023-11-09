// auto-generated, do not edit
import type { ShippingAddress } from '../shared';

export namespace GetPrintJobExploratoryMetadata {
  export interface Input {
    items: Array<{
      volumes: number[];
      printSize: 's' | 'm' | 'xl';
      quantity: number;
    }>;
    email: string;
    address: ShippingAddress;
  }

  export interface Output {
    shippingLevel:
      | 'mail'
      | 'priorityMail'
      | 'groundHd'
      | 'groundBus'
      | 'ground'
      | 'expedited'
      | 'express';
    shipping: number;
    taxes: number;
    fees: number;
    creditCardFeeOffset: number;
  }
}
