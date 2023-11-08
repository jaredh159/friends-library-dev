import React from 'react';
import { Link } from 'react-router-dom';
import { OrderSource, PrintJobStatus } from '../../graphql/globalTypes';
import { money } from '../../lib/money';
import { useQuery } from '../../lib/query';
import api, { type T } from '../../api-client';

interface Props {
  orders: T.ListOrders.Output;
}

export const ListOrders: React.FC<Props> = ({ orders }) => (
  <div className="space-y-3 mt-6">
    <h1 className="label pt-2">Orders: ({orders.length})</h1>
    {orders.map((order) => (
      <Link
        to={`/orders/${order.id}`}
        key={order.id}
        className="flex space-x-4 items-center bg-gray-100/75 hover:bg-blue-100/50 rounded-lg p-3"
      >
        <span className="label md:w-[9%]">
          {new Date(order.createdAt).toLocaleDateString()}
        </span>
        <span className="subtle-text capitalize">
          {order.addressName.toLocaleLowerCase()}
        </span>
        <span className="label">{money(order.amountInCents)}</span>
        {order.source === OrderSource.internal && (
          <span className="text-[10px] px-2 py-px bg-flgreen/75 text-white antialiased font-light uppercase rounded-lg">
            free
          </span>
        )}
      </Link>
    ))}
  </div>
);

const ListOrdersContainer: React.FC = () => {
  const query = useQuery(() => api.listOrders());
  if (!query.isResolved) {
    return query.unresolvedElement;
  }
  const orders = [...query.data].filter(
    (order) => order.printJobStatus !== PrintJobStatus.bricked,
  );
  orders.sort((a, b) => (a.createdAt < b.createdAt ? 1 : -1));
  return <ListOrders orders={orders} />;
};

export default ListOrdersContainer;
