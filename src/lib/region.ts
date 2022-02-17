import { Friend } from '../build/types';

export function documentRegion(friend: Friend): string {
  if (friend.isCompilations) {
    return `Other`;
  }
  switch (friend.primaryResidence?.region) {
    case `Ireland`:
      return `Ireland`;
    case `England`:
      return `England`;
    case `Scotland`:
      return `Scotland`;
    case `Wales`:
    case `Netherlands`:
    case `France`:
    case `Ohio`:
      return `Western US`;
    case `Delaware`:
    case `Pennsylvania`:
    case `New Jersey`:
    case `Rhode Island`:
    case `New York`:
    case `Vermont`:
      return `Eastern US`;
    default:
      throw new Error(
        `Error inferring explore region for friend: ${friend.name}/${friend.lang}`,
      );
  }
}
