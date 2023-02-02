import { gql } from '@apollo/client';
import type {
  CreateFriendQuote,
  CreateFriendQuoteVariables,
} from '../../../graphql/CreateFriendQuote';
import type { DeleteFriendQuote } from '../../../graphql/DeleteFriendQuote';
import type { UpdateFriendQuoteInput } from '../../../graphql/globalTypes';
import type {
  UpdateFriendQuote,
  UpdateFriendQuoteVariables,
} from '../../../graphql/UpdateFriendQuote';
import type { EditableFriendQuote, ErrorMsg } from '../../../types';
import client from '../../../client';
import { mutate, prepIds } from './helpers';

export async function create(quote: EditableFriendQuote): Promise<ErrorMsg | null> {
  return mutate(`create`, quote, () =>
    client.mutate<CreateFriendQuote, CreateFriendQuoteVariables>({
      mutation: CREATE_QUOTE,
      variables: { input: quoteInput(quote) },
    }),
  );
}

export async function update(quote: EditableFriendQuote): Promise<ErrorMsg | null> {
  return mutate(`update`, quote, () =>
    client.mutate<UpdateFriendQuote, UpdateFriendQuoteVariables>({
      mutation: UPDATE_QUOTE,
      variables: { input: quoteInput(quote) },
    }),
  );
}

async function remove(quote: EditableFriendQuote): Promise<ErrorMsg | null> {
  return mutate(`delete`, quote, () =>
    client.mutate<DeleteFriendQuote, IdentifyEntity>({
      mutation: DELETE_QUOTE,
      variables: prepIds({ id: quote.id }),
    }),
  );
}

export { remove as delete };

// mutations

const CREATE_QUOTE = gql`
  mutation CreateFriendQuote($input: CreateFriendQuoteInput!) {
    quote: createFriendQuote(input: $input) {
      id
    }
  }
`;

const UPDATE_QUOTE = gql`
  mutation UpdateFriendQuote($input: UpdateFriendQuoteInput!) {
    quote: updateFriendQuote(input: $input) {
      id
    }
  }
`;

const DELETE_QUOTE = gql`
  mutation DeleteFriendQuote($id: UUID!) {
    quote: deleteFriendQuote(id: $id) {
      id
    }
  }
`;

// helpers

export function quoteInput(quote: EditableFriendQuote): UpdateFriendQuoteInput {
  return prepIds({
    id: quote.id,
    friendId: quote.friend.id,
    order: quote.order,
    source: quote.source,
    text: quote.text,
  });
}
