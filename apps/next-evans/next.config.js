// load env from monorepo root
require(`dotenv`).config({ path: `../../.env` });

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
};

module.exports = nextConfig;
