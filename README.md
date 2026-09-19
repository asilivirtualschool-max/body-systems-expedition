# Finding Out: Body Systems Expedition

A collaborative research workbook for the **Finding Out** stage of a Grade 5 human body inquiry (IB PYP).

Five expert groups each investigate one body system. Within a group, three investigators take different angles — **Structure**, **Function** and **Connections** — research separately, and pool what they find into one shared evidence bank. At the end, each student's work becomes a PowerPoint they can present, quiz slides included.

It is one HTML file. Nothing to install, no accounts, no data leaves the students' browsers.

**▶ Open it here:** https://asilivirtualschool-max.github.io/body-systems-expedition/

![The Investigate stage, with the group evidence bank and team panel](docs/investigate.png)

---

## How a lesson runs

1. **One student starts the group.** They pick the body system, get a code (PULSE, ALVEOLI, NEURON…), and read it out.
2. **Everyone else joins with that code.** They inherit the system automatically and land in Base Camp.
3. **Each student claims a role.** Structure, Function or Connections — a claimed role locks, so no two students can take the same one.
4. **The group sets off through seven stages:** Mission Brief → Learn to Research → Ask Your Question → Investigate → Check Evidence → Build Summary → Ready to Present.
   - On **Investigate**, each student's own three questions are listed down the page, each with search prompts shaped by their system, role and related concept ("parts of the circulatory system for kids", "📋 Copy my question"), the facts they have found filed underneath it, and a *summary in my own words* box at the end.
   - On **Build Summary**, they tick which facts go on the slides and watch the **slide preview** rebuild — the same slide plan the PowerPoint generator uses, so what is on screen is what downloads. A coverage panel checks their evidence against the role they claimed and the concepts they chose.
5. **Each student downloads their own PowerPoint and PDF** at the end. Their group's shared evidence and group summary are in there too.

A group is three students, one per role. Bigger classes run several groups at once — each group has its own code and its own evidence bank.

## Seeing the end product while they build it

![The coverage check and the slide preview on Build Summary](docs/slide-preview.png)

Build Summary shows the deck as it stands — the same slide plan the PowerPoint generator uses, so the preview cannot drift from the file that downloads. Above it, a coverage panel reads the evidence back against the role the student claimed and the related concepts they chose, and names the gaps rather than just counting facts.

## What the students share, live

| | |
|---|---|
| **Group evidence bank** | Any fact a student ticks *Share with my group* appears instantly in everyone's sidebar, tagged with who found it and their role. *Add to my notes* pulls a teammate's fact into your own journal — their name stays attached to it, in the app, in the PDF and on the slide. |
| **Question 3** | The workbook asks for one question written with a partner. Pick a teammate and you both type into the same box, with a "✍ Yusuf is writing…" indicator. |
| **Group summary** | One paragraph the whole group writes together on Stage 6, alongside each student's own summary. |
| **Group quiz link** | One person pastes the Kahoot/Form/Quizizz link; it lands in everyone's deck. |
| **Presence** | Avatars in the top bar, each teammate's current stage in the sidebar, and coloured dots under every stage tile. A teammate shows as offline if their laptop has been quiet for 45 seconds. |
| **Chat** | A group chat panel, with system messages when someone shares a fact or earns a key. |

### Group keys, not locked doors

Six **keys** unlock when *everyone online* finishes a stage — with a chime, a toast and a mark in the sidebar. They are a reward, not a gate: nobody is ever blocked, so a flat battery or an absent student never strands the group.

## The quiz

On Stage 6, students write up to three multiple-choice questions about their system. Each becomes a **quiz slide** in the deck, followed by an **answer-reveal slide** — so the presenter can pause and let the class guess. Wrong answers have to be believable, which is the point.

If the group also made a quiz elsewhere (Kahoot, Blooket, Quizizz, a Google Form), pasting the link adds a final slide with a **scannable QR code** and a clickable hyperlink. The QR code is generated inside the HTML file — no QR website, no internet, nothing sent anywhere.

## Systems check

![The built-in systems check](docs/systems-check.png)

There is a **Systems check** button on the opening screen and in the top bar. It runs about twenty checks — this device, the group connection, the PowerPoint and PDF builders, the QR generator, all seven stages — and reports in plain language, with a **Copy this report** button.

Worth running once on a fresh set of laptops before a lesson. A failure tells you what to do: a blocked connection means groups can't form (solo mode still works); a missing toolkit means that laptop had no internet the first time the page loaded.

## Research integrity, built in

- Pasting into a fact or summary box is detected — the student is asked to reword it and tick a box to confirm.
- The evidence bank on Stage 6 has copying switched off, so the summary has to be written from memory.
- Every fact carries its source title, author and date, and a required reason for choosing that source.
- Borrowed facts keep the teammate's name on them everywhere they appear.

## How groups sync

Groups sync through a **Firebase Realtime Database** — ordinary HTTPS on port 443, which school networks allow.

This replaced an earlier browser-to-browser (WebRTC) design that could not work at school: the network blocks the UDP that WebRTC needs, so no peer connection ever formed and joining hung for ever. Testing on the school network found zero STUN-reflexive candidates and no reachable TURN relay, while Firebase answered in 1.2 seconds.

The relay is better in three other ways as well:

- **No host.** Nobody has to keep a tab open. Everyone reads and writes the same room.
- **Reloading is safe.** A student who refreshes, or whose laptop sleeps, rejoins with the code and the group's evidence is still there.
- **It degrades gracefully.** Live updates stream over `text/event-stream`; if a proxy buffers that, the workbook falls back to checking every couple of seconds on its own.

The database address is baked into the file. To point a copy at your own database instead, add `?db=https://your-db.firebasedatabase.app` to the address once — it is remembered on that device.

**Security rules** (Realtime Database → Rules) keep it scoped: a room can be read and written by anyone who knows its six-letter code, `/rooms` itself cannot be listed, so codes can't be enumerated, and rooms stop accepting writes 24 hours after they are created.

```json
{
  "rules": {
    "rooms": {
      "$code": {
        ".read": true,
        ".write": "!data.exists() || !data.child('meta/createdAt').exists() || data.child('meta/createdAt').val() > (now - 86400000)"
      }
    }
  }
}
```

What lives in the database: first names, chosen roles, which stage each student is on, facts they ticked *share with my group*, the co-written question and group summary, the quiz link and the chat. What never leaves the student's own browser: their personal journal, their own summary, and any images they upload.

### If a group still can't connect

- **Run the systems check** — it reaches the database, writes a test room and reads it back, and says in one line which step failed.
- **Work on my own** on the opening screen gives the full single-student workbook, quiz and exports included.

## What students get out of it

- `*-finding-out-presentation.pptx` — title, questions, then **their facts grouped under the question each one answers**, with the related concept under the heading and the full source under every fact; the group's shared evidence, both summaries, images with numbered annotations, quiz slides, sources.
- `*-finding-out-notes.pdf` — a tidy record of questions, facts, decision-making, group evidence and images.
- `*.txt` — a plain-text backup that works with no internet at all.

## Curriculum notes

- Built around the IB PYP **Approaches to Learning** — research skills, **decision-making** (why this source, what to keep, what you'd decide differently) and **collaboration** (share, read, build on rather than repeat).
- The related-concept scaffolds — Form, Function, Connection, Causation — shape each role's questions.
- The "How do I know I'm done researching?" checklist is the class's own.

---

## For developers

```bash
npm install                 # playwright
npx playwright install chromium
./build.sh                  # src/* -> index.html
npm test                    # 5 suites, ~60 checks
npm run serve               # http://localhost:8080
```

`index.html` is generated and committed — CI rebuilds it and fails if it is out of date.

```
src/shell.html              markup + CSS, opens the <script> tag
src/qr.js                   QR encoder written from scratch (byte mode, EC level M, v1–10)
src/data.js                 systems, roles, research skills, checklists, state
src/relay.js                the database relay — REST writes, streaming reads, polling fallback
src/network.js              lobby, room join/create, presence, chat, keys
src/render.js               stage rendering, team views, timer
src/events-and-exports.js   stage events, quiz builder, PPTX/PDF/TXT generation
src/systems-check.js        the built-in diagnostics
```

Tests run headless Chromium against the built file:

| | |
|---|---|
| `01-solo.js` | one student through all seven stages |
| `02-collaboration.js` | two browser contexts in one group against the real database — roster, role locking, shared bank, shared fields, keys, group timer (skips with no internet; `06` covers the same ground offline) |
| `03-exports.js` | every slide, PDF section and text section, from a fully populated workbook |
| `04-systems-check.js` | runs the app's own systems check and asserts the offline-safe parts pass |
| `05-qr.js` | QR matrices against fixtures that were verified by decoding with OpenCV **and** compared module-for-module with the reference `python-qrcode` encoder |
| `06-relay.js` | two students syncing through a stand-in for the Firebase REST API (`tests/mock-rtdb.js`) — rooms, role locking, shared bank, co-written fields, keys, timer, and a student reloading mid-lesson |

The three CDN libraries (pptxgenjs, jsPDF, PeerJS) are the only external dependencies at runtime. Tests stub the first two so the suite passes with no internet, and additionally build real files when internet is available.

## Licence

MIT — see [LICENSE](LICENSE). Use it, fork it, adapt it for your own unit.
