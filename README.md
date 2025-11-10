# Download and Archiving Script

## Description

This Bash script downloads JSON files from a list of URLs and organizes the results into folders.

## Prerequisites

- Bash
- curl

## Usage

```bash
./run.sh <urls_file> <downloads_dir> <archives_dir>
```

### Parameters

1. **urls_file**: Text file containing one URL per line
2. **downloads_dir**: Directory where JSON files will be copied
3. **archives_dir**: Directory for archives (required parameter but currently unused)

### Example

```bash
./run.sh urls.txt downloads archives
```

## What does the script do?

1. Reads URLs from the provided file
2. Downloads each file into a temporary directory (`tmp/`)
3. Copies all `.json` files to the downloads directory
4. Consolidates all HTTP headers into a `headers.txt` file
5. Cleans up the temporary directory

## File Structure

```
.
├── run.sh              # Main script
├── urls.txt            # Your URLs file (to be created)
├── downloads/          # Downloaded JSON files (created automatically)
│   ├── *.json
│   └── headers.txt
└── tmp/                # Temporary directory (created/deleted automatically)
```
