| Total bytes | Value | Translation |
|:-:|:-:||:-:|
| 16 bytes | `\x73\x20\x74\x20\x61\x20\x72\x20\x31\x00\x00...` | `=> s t a r 1\x00..16` |
| 8 bytes | `\xCA\xFE\xCA\xFE\xBA\xBE\xBA\xBE`  | `Begin file list` |
| n bytes | `filename{*&*}filehash{:\x00:}filename{*&*}filehash{:\x00:}...`  | The file list separated by {:\x00:} |
| 8 bytes | `\xBA\xBE\xBA\xBE\xCA\xFE\xCA\xFE`  | `End file list` |
| 24 bytes | `\x53\x20\x54\x20\x41\x20\x52\x20\x42\x20\x45\x20\x47\x20\x49\x20\x4e\x20\x5c\x20\x5c\x20\x26\x24` | `Beginning of file (S T A R B E G I N \ \ &$)` |
| n bytes  | file contents  | The contents of the file |
| 24 bytes | `\x53\x20\x54\x20\x41\x20\x52\x20\x45\x20\x4e\x20\x44\x20\x4f\x20\x46\x20\x5c\x20\x5c\x20\x26\x24` | `End of file (S T A R E N D O F \ \ &$)` |
| n bytes | `{begin file hex}{file contents}{end of file hex}` | repeat for every file |
| 16 bytes | `\x65\x20\x73\x20\x74\x20\x61\x20\x72\x00\x00...`| end of star file |