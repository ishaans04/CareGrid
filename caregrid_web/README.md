# CareGrid submission prototype

Team Duality · local interactive product demonstration · synthetic data only.

Run with Node 22 or newer (no dependency installation):

```powershell
cd E:\Projects\CareGrid-\caregrid_web
npm.cmd start
```

Open <http://127.0.0.1:4173>. Tests: `npm.cmd test`.

Command, incident workspace, responder, care, readiness and analytics views share browser-local state. Dispatch, acceptance, movement, arrival, care and closure are explicit actions. A missed-ACK scenario requires alternate-unit escalation. A what-if model demonstrates a compound-failure intervention. Reset clears this prototype's local demo state only. JSON export contains synthetic case/audit data.

The role/view selector illustrates intended product views; it is **not authentication or backend authorization**. No camera, live GPS, emergency service, Gemini, Maps or Firebase is connected. The campus drawing and evidence scene are original code illustrations. Google integration labels describe the proposed architecture and are labeled as such. This frontend does not yet call the existing Serverpod application. Integration requirements: [implementation plan](../docs/buildathon/IMPLEMENTATION-PLAN.md).

Design follows the supplied `12112026/CareGrid v2.dc.html`: ink, warm paper, lime and cyan; Archivo, Instrument Serif and Martian Mono; fine rules, numbered sections, editorial hierarchy and a schematic campus. Local fonts have system fallbacks. All numbers are fixtures, illustrative predictions or demo observations, never customer outcomes.

Direct view links: `/#overview`, `/#incident`, `/#responder`, `/#care`, `/#readiness`, `/#analytics`. Reproducible synthetic capture fixtures: `?demo=verified`, `?demo=dispatched`, `?demo=active`, `?demo=care`, `?demo=readiness`, `?demo=outcome`, followed by a view hash. These reset the initial in-memory demo on page load; remove the query to resume stored state. Keyboard navigation, focus styles, reduced-motion handling and responsive layouts are included.
