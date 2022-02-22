import React from 'react';
import { Link } from 'react-router-dom';
import { gql } from '../../client';
import { OrderSource, PrintJobStatus } from '../../graphql/globalTypes';
import { ListOrders as ListOrdersQuery } from '../../graphql/ListOrders';
import { money } from '../../lib/money';
import { useQueryResult } from '../../lib/query';

interface Props {
  orders: ListOrdersQuery['orders'];
}

export const ListOrders: React.FC<Props> = ({ orders }) => {
  return (
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
          <span className="label">{money(order.amount)}</span>
          {order.source === OrderSource.internal && (
            <span className="text-[10px] px-2 py-px bg-flgreen/75 text-white antialiased font-light uppercase rounded-lg">
              free
            </span>
          )}
        </Link>
      ))}
    </div>
  );
};

const ListOrdersContainer: React.FC = () => {
  const query = useQueryResult<ListOrdersQuery>(QUERY);
  if (!query.isResolved) {
    return query.unresolvedElement;
  }
  const orders = [...query.data.orders].filter(
    (order) => order.printJobStatus !== PrintJobStatus.bricked,
  );
  orders.sort((a, b) => (a.createdAt < b.createdAt ? 1 : -1));
  return <ListOrders orders={orders} />;
};

export default ListOrdersContainer;

const QUERY = gql`
  query ListOrders {
    orders: getOrders {
      id
      amount
      addressName
      printJobStatus
      source
      createdAt
    }
  }
`;
