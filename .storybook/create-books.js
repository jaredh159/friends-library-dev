const fs = require(`fs`);
const { allFriends } = require('@friends-library/friends');

const friends = allFriends().filter((f) => f.hasNonDraftDocument);

fs.writeFileSync(
  `${__dirname}/../src/stories/books.ts`,
  `export default ` +
    JSON.stringify(
      friends.reduce(
        (acc, friend) => [
          ...acc,
          ...friend.documents.map((doc) => [doc.id, doc.title, friend.name]),
        ],
        [],
      ),
      null,
      2,
    ).replace(/"/g, `\``),
);
