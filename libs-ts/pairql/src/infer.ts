import type { Env } from './types';

export function inferEnvWeb(href: string): Env {
  if (
    href.includes(`https://deploy-preview-`) ||
    (href.startsWith(`https://`) && href.includes(`--staging`))
  ) {
    return `staging`;
  } else if (href.startsWith(`http://`)) {
    return `dev`;
  } else {
    return `prod`;
  }
}

export function inferEnvNode(
  process: { argv: string[]; env: Record<string, string | undefined> },
  pattern?: string,
): [env: Env, token?: string] {
  let env: Env = `dev`;
  if (process.argv.includes(`--api-staging`)) {
    env = `staging`;
  } else if (process.argv.includes(`--api-dev`)) {
    env = `dev`;
  } else {
    env = `prod`;
  }

  // `DEV` | `STAGING` | `PROD`
  const envFrag = env.toUpperCase();
  const placeholder = `{{env}}`;
  let token: string | undefined = undefined;

  if (!pattern) {
    token = requireEnvVar(`FLP_API_TOKEN_${envFrag}`, process.env);
  } else if (!pattern.includes(placeholder)) {
    throw new Error(`Token input pattern must include \`${placeholder}\``);
  } else {
    const key = pattern.replace(placeholder, envFrag);
    token = requireEnvVar(key, process.env);
  }

  return [env, token];
}

function requireEnvVar(key: string, env: Record<string, string | undefined>): string {
  const value = env[key];
  if (!value) {
    throw new Error(
      `Missing required environment var: \`${key}\` for inferring db client config`,
    );
  }
  return value;
}
