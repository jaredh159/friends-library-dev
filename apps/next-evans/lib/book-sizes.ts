import { Edition } from './types';

export function bookSize(size: Edition['size']): 'xl' | 's' | 'm' {
  return size === `xlCondensed` ? `xl` : size;
}
