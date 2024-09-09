final List<Map<String, dynamic>> therapiesCataract = [
  // Acupressure Therapy
  {
    "title": "Acupressure",
    "timeLimit": 2,
    "type": "instruction",
    "svgPath": "assets/images/cataracts/acupressure.png",
    "sound":
        "assets/audio/relaxing_breathing.mp3",
    "benefits": [
      "Promotes circulation around the eyes",
      "Reduces eye tension",
      "May alleviate cataract symptoms"
    ],
    "instructions": [
      {
        "step": 1,
        "instruction": "Find the spot just behind your earlobe.",
        "svgPath": "assets/images/cataracts/earlobe.png",
        "duration": 10
      },
      {
        "step": 2,
        "instruction":
            "Find the point that is the width of 1 thumb behind that.",
        "svgPath": "assets/images/cataracts/step2.png",
        "duration": 10
      },
      {
        "step": 3,
        "instruction": "Rub it gently 5 times.",
        "svgPath": "assets/images/cataracts/rub.png",
        "duration": 30
      },
      {
        "step": 4,
        "instruction": "Repeat 3 times a day for 30 days.",
        "svgPath": "assets/images/cataracts/acupressure.png",
        "duration": 60
      }
    ]
  },

  // Palming
  {
    "title": "Palming",
    "timeLimit": 5,
    "type": "image",
    "svgPath": "assets/images/palming/palming.png",
    "sound": "assets/audio/relaxing_breathing.mp3",
    "benefits": [
      "Relieves eye strain",
      "Promotes relaxation",
      "Soothes tired eyes"
    ],
    "instructions": [
      {
        "step": 1,
        "instruction": "Rub your palms together until warm.",
        "svgPath": "assets/images/palming/rub_palms.png",
        "duration": 10
      },
      {
        "step": 2,
        "instruction": "Place your warm palms over your eyes.",
        "svgPath": "assets/images/palming/coverEyes.png",
        "duration": 10
      },
      {
        "step": 3,
        "instruction": "Relax your eyes under the warmth.",
        "svgPath": "assets/images/palming/close_eyes.png",
        "duration": 10
      },
      {
        "step": 4,
        "instruction": "Continue this therapy.",
        "svgPath": "assets/images/palming/palming.png",
        "duration": 250
      },
    ]
  },

  // Focus Shifting
  {
    "title": "Focus Shifting",
    "timeLimit": 3,
    "type": "image",
    "svgPath": "assets/images/focus_shifting/focus_shifting.png",
    "sound": "assets/audio/relaxing_breathing.mp3",
    "benefits": [
      "Improves eye focus and flexibility",
      "Reduces eye strain from close work"
    ],
    "instructions": [
      {
        "step": 1,
        "instruction": "Hold your thumb about 10 inches away from your face.",
        "svgPath": "assets/images/focus_shifting/thumb.png",
        "duration": 20
      },
      {
        "step": 2,
        "instruction": "Focus on your thumb for a few seconds.",
        "svgPath": "assets/images/focus_shifting/focus_thumb.png",
        "duration": 30
      },
      {
        "step": 3,
        "instruction": "Shift your focus to something farther away.",
        "svgPath": "assets/images/distance_gazing/far.png",
        "duration": 30
      },
      {
        "step": 4,
        "instruction": "Shift your focus back to your thumb.",
        "svgPath": "assets/images/focus_shifting/focus_thumb.png",
        "duration": 30
      },
      {
        "step": 5,
        "instruction": "Repeat the focus shifting.",
        "svgPath": "assets/images/focus_shifting/thumb.png",
        "duration": 30
      },
    ]
  },

  //eye rolling
  {
    "title": "Eye Rolling",
    "timeLimit": 2,
    "type":
        "animation_eye_rolling",
    "svgPath":
        "assets/images/eye_rolling/eye_rolling.png",
    "sound": "assets/audio/relaxing_breathing.mp3",
    "benefits": [
      "Strengthens eye muscles",
      "Reduces eye strain",
      "Improves eye flexibility"
    ],
    "instructions": [
      {
        "step": 1,
        "instruction": "Roll your eyes in a circular motion.",
        "svgPath":
            "assets/images/eye_rolling/roll_eyes.png",
        "duration": 10
      }
    ]
  }
];
