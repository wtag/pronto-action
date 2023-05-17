# Pronto Action

This action runs pronto.

## Inputs

### `github_token`

**Required** The token to use to leave the pronto comments.

## Example usage

```yaml
uses: wtag/pronto-action@master
  with:
  github_token: ${{ secrets.GITHUB_TOKEN }}
```

### MonoRepo

```yaml
uses: wtag/pronto-action@master
  with:
  github_token: ${{ secrets.GITHUB_TOKEN }}
  code_directory: ferryhub-core
```
