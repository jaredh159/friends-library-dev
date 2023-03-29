# Github Action to Upload a File to Digital Ocean Spaces

A simple github action for uploading files to Digital Ocean Spaces. The S3-focused actions
I found hardcoded assumptions about uploading to an actual Amazon S3 bucket and didn't
allow customizing the endpoint to take advantage of the fact that DO Spaces is S3
compatible and works (if you specify the endpoint) with the `aws` cli.

## Usage

```yaml
# inside .github/workflows/your-action.yml
name: upload some file
on: push

jobs:
  upload:
    runs-on: ubuntu-latest
    steps:
      name: upload something
      uses: friends-library-dev/action-do-spaces-upload@master
        with:
          src-file-path: ./some-file.txt
          destination-object-key: destination/object/key/file.txt
          access-key-id: ${{ secrets.DO_SPACES_KEY_ID }}
          access-key-secret: ${{ secrets.DO_SPACES_KEY_SECRET }}
          bucket: ${{ secrets.DO_SPACES_BUCKET }}
          region: ${{ secrets.DO_SPACES_REGION }}}
          acl: public-read # optional - default: private
          remove-src-after-upload: true # optional - default: false
```

List of possible values for `acl`:

- `private` _default_
- `public-read`
- `public-read-write`
