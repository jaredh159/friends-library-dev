// load env from monorepo root
require(`dotenv`).config({ path: `../../.env` });
const LANG = process.env.NEXT_PUBLIC_LANG || `en`;

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  transpilePackages: [`@friends-library`, `x-syntax`],
  rewrites: async function () {
    if (LANG === `en`) return [];
    return {
      afterFiles: [
        {
          source: `/amigos`,
          destination: `/friends`,
        },
      ],
    };
  },
  redirects: async function () {
    if (LANG === `en`) return [];
    return [
      {
        source: `/friends`,
        destination: `/amigos`,
        permanent: false,
      },
    ];
  },
};

module.exports = nextConfig;
