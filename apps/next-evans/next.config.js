// @ts-check
// load env from monorepo root
require(`dotenv`).config({ path: `../../.env` });
const LANG = process.env.NEXT_PUBLIC_LANG || `en`;

/** @type {import('next').NextConfig} */
const nextConfig = {
  transpilePackages: [`@friends-library`, `x-syntax`],
  rewrites: async function () {
    return {
      afterFiles: [],
      fallback: [],
      beforeFiles: [
        ...staticFiles(),
        {
          source: `/amigo/:path*`,
          destination: `/friend/:path*`,
        },
        {
          source: `/amiga/:path*`,
          destination: `/friend/:path*`,
        },
        {
          source: `/compilaciones`,
          destination: `/friend/compilaciones`,
        },
        {
          source: `/compilations`,
          destination: `/friend/compilations`,
        },
      ],
    };
  },
  redirects: async function () {
    return [
      {
        source: `/static/:path*`,
        destination: `/:path*`,
        permanent: true,
      },
      {
        source: `/friend/compilations`,
        destination: `/compilations`,
        permanent: true,
      },
      {
        source: `/amiga/compilaciones`,
        destination: `/compilaciones`,
        permanent: true,
      },
      {
        source: `/amigo/compilaciones`,
        destination: `/compilaciones`,
        permanent: true,
      },
    ];
  },
};

module.exports = nextConfig;

function staticFiles() {
  if (LANG === `en`) {
    return [
      `about`,
      `app-privacy`,
      `audio-help`,
      `ebook-help`,
      `modernization`,
      `editions`,
      `plain-text-format`,
      `quakers`,
      `spanish-translations`,
    ].map((slug) => ({
      source: `/${slug}`,
      destination: `/static/${slug}`,
    }));
  }
  return [
    [`about`, `acerca-de-este-sitio`],
    [`app-privacy`, `app-privacidad`],
    [`audio-help`, `audio-ayuda`],
    [`ebook-help`, `ebook-ayuda`],
    [`plain-text-format`, `descargar-texto-sin-formato`],
    [`quakers`, `cuaqeros`],
    [`spanish-translations`, `nuestras-traducciones`],
  ].map(([en, es]) => ({
    source: `/${es}`,
    destination: `/static/${en}`,
  }));
}
