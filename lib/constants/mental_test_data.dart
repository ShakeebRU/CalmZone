// final List<Map<String, dynamic>> mentalTestData = [
//   {
//     "question": "How often do you feel low or depressed?",
//     "options": [
//       {"text": "Not at all", "score": 0},
//       {"text": "Several days", "score": 1},
//       {"text": "More than half days", "score": 2},
//       {"text": "Nearly every day", "score": 3},
//     ],
//   },
//   {
//     "question": "Do you feel anxious without reason?",
//     "options": [
//       {"text": "Never", "score": 0},
//       {"text": "Sometimes", "score": 1},
//       {"text": "Often", "score": 2},
//       {"text": "Always", "score": 3},
//     ],
//   },
//   {
//     "question": "Do you have trouble sleeping?",
//     "options": [
//       {"text": "No issue", "score": 0},
//       {"text": "Occasionally", "score": 1},
//       {"text": "Frequently", "score": 2},
//       {"text": "Almost every night", "score": 3},
//     ],
//   },
// ];
// ============================================================
// ALL 16 QUESTIONS — NO TEST NAME SHOWN TO USER
// ============================================================

final List<Map<String, dynamic>> mentalTestData = [
  {
    "id": 1,
    "testTag": "PHQ-9", // internal only, never show to user
    "question": "Little interest or pleasure in doing things?",
    "options": [
      {"text": "Not at all", "score": 0},
      {"text": "Several days", "score": 1},
      {"text": "More than half the days", "score": 2},
      {"text": "Nearly every day", "score": 3},
    ],
  },
  {
    "id": 2,
    "testTag": "PHQ-9",
    "question": "Feeling down, depressed, or hopeless?",
    "options": [
      {"text": "Not at all", "score": 0},
      {"text": "Several days", "score": 1},
      {"text": "More than half the days", "score": 2},
      {"text": "Nearly every day", "score": 3},
    ],
  },
  {
    "id": 3,
    "testTag": "PHQ-9",
    "question": "Trouble falling or staying asleep, or sleeping too much?",
    "options": [
      {"text": "Not at all", "score": 0},
      {"text": "Several days", "score": 1},
      {"text": "More than half the days", "score": 2},
      {"text": "Nearly every day", "score": 3},
    ],
  },
  {
    "id": 4,
    "testTag": "PHQ-9",
    "question": "Feeling tired or having little energy?",
    "options": [
      {"text": "Not at all", "score": 0},
      {"text": "Several days", "score": 1},
      {"text": "More than half the days", "score": 2},
      {"text": "Nearly every day", "score": 3},
    ],
  },
  {
    "id": 5,
    "testTag": "PHQ-9",
    "question": "Poor appetite or overeating?",
    "options": [
      {"text": "Not at all", "score": 0},
      {"text": "Several days", "score": 1},
      {"text": "More than half the days", "score": 2},
      {"text": "Nearly every day", "score": 3},
    ],
  },
  {
    "id": 6,
    "testTag": "PHQ-9",
    "question":
        "Feeling bad about yourself — or that you are a failure or have let yourself or your family down?",
    "options": [
      {"text": "Not at all", "score": 0},
      {"text": "Several days", "score": 1},
      {"text": "More than half the days", "score": 2},
      {"text": "Nearly every day", "score": 3},
    ],
  },
  {
    "id": 7,
    "testTag": "PHQ-9",
    "question":
        "Trouble concentrating on things, such as reading the newspaper or watching television?",
    "options": [
      {"text": "Not at all", "score": 0},
      {"text": "Several days", "score": 1},
      {"text": "More than half the days", "score": 2},
      {"text": "Nearly every day", "score": 3},
    ],
  },
  {
    "id": 8,
    "testTag": "PHQ-9",
    "question":
        "Moving or speaking so slowly that other people could have noticed? Or so fidgety or restless that you have been moving a lot more than usual?",
    "options": [
      {"text": "Not at all", "score": 0},
      {"text": "Several days", "score": 1},
      {"text": "More than half the days", "score": 2},
      {"text": "Nearly every day", "score": 3},
    ],
  },
  {
    "id": 9,
    "testTag": "PHQ-9",
    "question":
        "Thoughts that you would be better off dead, or thoughts of hurting yourself in some way?",
    "options": [
      {"text": "Not at all", "score": 0},
      {"text": "Several days", "score": 1},
      {"text": "More than half the days", "score": 2},
      {"text": "Nearly every day", "score": 3},
    ],
  },
  {
    "id": 10,
    "testTag": "GAD-7",
    "question": "Feeling nervous, anxious, or on edge?",
    "options": [
      {"text": "Not at all", "score": 0},
      {"text": "Several days", "score": 1},
      {"text": "More than half the days", "score": 2},
      {"text": "Nearly every day", "score": 3},
    ],
  },
  {
    "id": 11,
    "testTag": "GAD-7",
    "question": "Not being able to stop or control worrying?",
    "options": [
      {"text": "Not at all", "score": 0},
      {"text": "Several days", "score": 1},
      {"text": "More than half the days", "score": 2},
      {"text": "Nearly every day", "score": 3},
    ],
  },
  {
    "id": 12,
    "testTag": "GAD-7",
    "question": "Worrying too much about different things?",
    "options": [
      {"text": "Not at all", "score": 0},
      {"text": "Several days", "score": 1},
      {"text": "More than half the days", "score": 2},
      {"text": "Nearly every day", "score": 3},
    ],
  },
  {
    "id": 13,
    "testTag": "GAD-7",
    "question": "Trouble relaxing?",
    "options": [
      {"text": "Not at all", "score": 0},
      {"text": "Several days", "score": 1},
      {"text": "More than half the days", "score": 2},
      {"text": "Nearly every day", "score": 3},
    ],
  },
  {
    "id": 14,
    "testTag": "GAD-7",
    "question": "Being so restless that it is hard to sit still?",
    "options": [
      {"text": "Not at all", "score": 0},
      {"text": "Several days", "score": 1},
      {"text": "More than half the days", "score": 2},
      {"text": "Nearly every day", "score": 3},
    ],
  },
  {
    "id": 15,
    "testTag": "GAD-7",
    "question": "Becoming easily annoyed or irritable?",
    "options": [
      {"text": "Not at all", "score": 0},
      {"text": "Several days", "score": 1},
      {"text": "More than half the days", "score": 2},
      {"text": "Nearly every day", "score": 3},
    ],
  },
  {
    "id": 16,
    "testTag": "GAD-7",
    "question": "Feeling afraid as if something awful might happen?",
    "options": [
      {"text": "Not at all", "score": 0},
      {"text": "Several days", "score": 1},
      {"text": "More than half the days", "score": 2},
      {"text": "Nearly every day", "score": 3},
    ],
  },
];

// // ============================================================
// // COMBINED SCORING — PERCENTAGE OUT OF 100
// // ============================================================

// // Max possible: PHQ-9 = 27, GAD-7 = 21, Total = 48

// const int phqMaxScore = 27;
// const int gadMaxScore = 21;
// const int totalMaxScore = 48; // 27 + 21

// Map<String, dynamic> calculateMentalHealthResult(List<int> selectedScores) {
//   // selectedScores: 16 values, index 0–8 = PHQ-9, index 9–15 = GAD-7

//   int phq9Score = 0;
//   for (int i = 0; i <= 8; i++) {
//     phq9Score += selectedScores[i];
//   }

//   int gad7Score = 0;
//   for (int i = 9; i <= 15; i++) {
//     gad7Score += selectedScores[i];
//   }

//   int combinedScore = phq9Score + gad7Score;

//   // Percentage out of 100
//   double percentage = (combinedScore / totalMaxScore) * 100;
//   double roundedPercentage = double.parse(percentage.toStringAsFixed(1));

//   // Severity label based on percentage
//   String severity;
//   int severityColor;

//   if (roundedPercentage <= 16) {
//     severity = "Minimal";
//     severityColor = 0xFF4CAF50; // Green
//   } else if (roundedPercentage <= 37) {
//     severity = "Mild";
//     severityColor = 0xFFFFEB3B; // Yellow
//   } else if (roundedPercentage <= 58) {
//     severity = "Moderate";
//     severityColor = 0xFFFF9800; // Orange
//   } else if (roundedPercentage <= 79) {
//     severity = "Moderately Severe";
//     severityColor = 0xFFFF5722; // Deep Orange
//   } else {
//     severity = "Severe";
//     severityColor = 0xFFF44336; // Red
//   }

//   return {
//     "phq9Score": phq9Score, // internal
//     "gad7Score": gad7Score, // internal
//     "combinedScore": combinedScore, // internal
//     "totalMaxScore": totalMaxScore, // 48
//     "percentage": roundedPercentage, // e.g. 65.0
//     "severity": severity, // e.g. "Moderate"
//     "color": severityColor, // Flutter Color hex
//     "displayResult":
//         "$roundedPercentage% — $severity", // e.g. "65.0% — Moderate"
//   };
// }


// ============================================================
// SEVERITY BANDS REFERENCE (percentage based)
// ============================================================

// 0%   – 16%  → Minimal          (score 0–7  out of 48)
// 17%  – 37%  → Mild             (score 8–18 out of 48)
// 38%  – 58%  → Moderate         (score 19–27 out of 48)
// 59%  – 79%  → Moderately Severe(score 28–38 out of 48)
// 80%  – 100% → Severe           (score 39–48 out of 48)


// ============================================================
// USAGE EXAMPLE
// ============================================================

// List<int> selectedScores = [1, 2, 0, 1, 3, 0, 2, 1, 0,   // PHQ-9 answers
//                             2, 1, 3, 0, 2, 1, 2];          // GAD-7 answers
//
// Map<String, dynamic> result = calculateMentalHealthResult(selectedScores);
//
// // Show to user:
// print(result["displayResult"]);  // "43.8% — Moderate"
// print(result["percentage"]);     // 43.8
// print(result["severity"]);       // "Moderate"
// Color myColor = Color(result["color"]); // Orange
//
// // Internal use only (never show test names to user):
// print(result["phq9Score"]);      // 10
// print(result["gad7Score"]);      // 11
// print(result["combinedScore"]);  // 21