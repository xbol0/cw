# cw

Concat Word list collection

This script can help you concat multi categories online word dictionaries.

---

## Usage

Download this script to your `PATH`.

```
# Show help and all categories.
cw -h

# Examples:
# Basic Usage.
cw pw500
cw pw500 df

# Save to a file.
cw pw500 >words.txt

# Use CDN.
cw -j pw500 df
cw -f pw500 df

# Work with other tools.
cw -j pw500 | head -50 | xxx
```

## License

MIT License.