---
description: Find outdated memories that have been superseded. Returns IDs for manual deletion.
template: >
  Search Engram for memories that have been superseded by newer entries.
  Do this by searching for "UPDATED" and "replaces earlier memory" across
  all memories.


  For each memory that contains "UPDATED" or "replaces earlier memory" in
  its content, search for OLDER memories with the same subject keywords.


  Present the results as a table:


  OUTDATED (safe to delete):
  | ID | Title | Date | Replaced By |


  CURRENT (keep these):
  | ID | Title | Date |


  After presenting the table, give me the exact curl commands to delete
  the outdated ones. Format:

  curl -X DELETE http://localhost:7437/observations/{id}


  Do NOT delete anything yourself. Only show me the commands.
  I will run them manually after reviewing.
---
