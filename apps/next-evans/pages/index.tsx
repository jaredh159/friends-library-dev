import React from 'react';
import { PrismaClient } from '@prisma/client';
import type { friends } from '@prisma/client';
import type { GetStaticProps } from 'next';

export const getStaticProps: GetStaticProps = async () => {
  const prisma = new PrismaClient();
  const friends = await prisma.friends.findMany();
  return {
    props: {
      friends: friends.map((friend) => ({
        name: friend.name,
        gender: friend.gender,
      })),
    },
  };
};

const Home: React.FC<{ friends: friends[] }> = ({ friends }) => (
  <div>
    <h1 className="bg-flprimary text-white">
      Home, lang is <code className="text-red-700">{process.env.NEXT_PUBLIC_LANG}</code>
    </h1>
    <ul>
      {friends.map((friend) => (
        <li key={friend.id}>
          {friend.name} is {friend.gender}
        </li>
      ))}
    </ul>
  </div>
);

export default Home;
