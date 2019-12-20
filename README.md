# Pronto Action

This action runs pronto.

## Inputs

### `github_token`

**Required** The token to use to leave the pronto comments.

## Example usage

uses: wtag/pronto-action@master
  with:
  github_token: ${{ secrets.GITHUB_TOKEN }}
