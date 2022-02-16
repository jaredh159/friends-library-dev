# Converge TODOs:

- [ ] - creating an edition impression should DELETE others (on second thought, SQL unique
    constraint should prevent dupes, and in publish/handler we UPDATE when there is an
    existing... but think this through a bit)
- [ ] - Look at @TODO in MockDatabase, soft deletes
- [ ] - Would be nice to be able to Current.db.\* and assert on SQL produced (especially
    soft-deletes)
- [ ] - need to rethink/handle checking for NULL in db, current method stinky...
- [ ] - handle "entered into bowker" state for ISBN, see:
    https://github.com/friends-library-dev/cli/blob/master/src/cmd/isbns/entered.ts

- [ ] - ANOTHER_TODO

## done...

- [√] - write yaml import migration after all new migrations (shells out...)
- [√] - add foreign key migration to connect Download/OrderItem FK's AND Order->EditionId
- [√] - figure out related documents weirdness...
- [√] - hook up relations for all models (augmenting resolver tests)
- [√] - write basic crud stuff for all models (don't forget FriendResidence/Quote!)
- [√] - handle soft deletes (query, delete)
- [√] - generate throwing db and client extensions
- [√] - rename migrations numbers
- [√] - generate edition id map (from ts/cli land)
- [√] - write adding non-foreign key, nullable field migration
- [√] - migrate `order_items` to store Edition.Id instead of Document.Id AND edition type
- [√] - scaffold resolver tests
- [√] - scaffold repository
- [√] - scaffold resolver
- [√] - generate mocks
- [√] - take care of two models that didn't get converted
- [√] - redo insert db logic with protocol magic
- [√] - handle timestamps with special props or protocols
- [√] - generate Order.GraphQL.Inputs.create
- [√] - generate Order.GraphQL.Schema.type
- [√] - generate Order.GraphQL.Schema.createInput
- [√] - generate Order.GraphQL.Args.create
- [√] - generate convenience init (createInput)
- [√] - remove DuetInsertable, make it part of DuetModel
- [√] - remove force try!s in current live impl
- [√] - separate out live/mock into sub-repos, or something else
- [√] - change dep of live to be SQLDatabase
- [√] - remove from `Alt` faux namespace
- [√] - make some other files, and move stuff around
- [√] - restore graphql-kit
- [√] - pivot table for document related_documents
- [√] - ensure all usages of @OptionalChild have a uniqueness constraint, per vapor docs
- [√] - look at all migrations since 10, thinking through `unique(on:)` constraints
- [√] - pivot table for document tags
- [√] - table for isbns, with optional FK to edition 👍
- [√] - add new token scopes
- [√] - fix migration 14 (insert doc tags w DB somehow... 🤔)

## rando notes

- Document schema (in TS) has a "region" field, but I'm not sure if it's used anywhere,
  left it out of migration for now
- moved optional `print_size` prop from Document to Edition, i think it more correctly
  belongs there

- [ ] - ANOTHER_TODO

## what operations do we need?

- create/update/get a friend
- create/update/get a document
- create/update/get an edition
- create an EditionImpression (should replace old one...) (setEditionImpression?)

## REAL USE CASES...

Some "categories"

- build website
- stuff i currently do with friends.yml files (adding new docs, updating, publishing,
  audio/video stuff)
- Cover Web App (??? cover props?)
- Cron (handle print jobs, send tracking emails...)
- @TODO, keep going, review all APPS in monorepo

### Building Website

- get ALL friends, w/ all documents, w/ all editions+impresions, etc... KITCHEN SINK!
