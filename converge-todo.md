# Converge TODOs:

- [ ] - remove force try!s in current live impl
- [ ] - separate out live/mock into sub-repos, or something else
- [√] - change dep of live to be SQLDatabase
- [√] - remove from `Alt` faux namespace
- [√] - make some other files, and move stuff around
- [√] - restore graphql-kit
- [√] - pivot table for document related_documents
- [√] - ensure all usages of @OptionalChild have a uniqueness constraint, per vapor docs
- [√] - look at all migrations since 10, thinking through `unique(on:)` constraints
- [√] - pivot table for document tags
- [√] - table for isbns, with optional FK to edition 👍

## rando notes

- Document schema (in TS) has a "region" field, but I'm not sure if it's used anywhere,
  left it out of migration for now
- moved optional `print_size` prop from Document to Edition, i think it more correctly
  belongs there

- [ ] - ANOTHER_TODO
