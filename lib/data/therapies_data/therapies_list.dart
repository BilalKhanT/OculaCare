final List<Map<String, dynamic>> therapiesList = [
  // Mind-Chest Breathing
  {
    "title": "Mind-Chest Breathing",
    "timeLimit": 5, // Total duration in minutes
    "type": "image", // Specifies that this therapy only requires images
    "svgPath": "assets/images/mind_chest_breathing/mind-chest_breathing.png",
    "sound": "assets/audio/relaxing_breathing.mp3",
    "benefits": [
      "Helps to reduce stress",
      "Improves oxygen flow",
      "Promotes mental clarity"
    ],
    "instructions": [
      {
        "step": 1,
        "instruction": "Sit comfortably.",
        "svgPath": "assets/images/mind_chest_breathing/sit_comfortably.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 2,
        "instruction": "Close your eyes.",
        "svgPath": "assets/images/mind_chest_breathing/close_eyes.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 3,
        "instruction": "Focus on your breathing.",
        "svgPath": "assets/images/mind_chest_breathing/breathing_focus.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 4,
        "instruction": "Inhale deeply.",
        "svgPath": "assets/images/mind_chest_breathing/inhaling.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 5,
        "instruction": "Fill your chest with air.",
        "svgPath": "assets/images/mind_chest_breathing/fill_chest.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 6,
        "instruction": "Hold for a moment.",
        "svgPath": "assets/images/mind_chest_breathing/hold_breath.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 7,
        "instruction": "Exhale slowly.",
        "svgPath": "assets/images/mind_chest_breathing/exhaling.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 8,
        "instruction":
            "Continue to breathe deeply and focus on your breathing.",
        "svgPath":
            "assets/images/mind_chest_breathing/mind-chest_breathing.png",
        "duration":
            230 // Remaining duration in seconds (300 - 70 = 230 seconds)
      },
    ]
  },

  // Jumping Stripes
  {
    "title": "Jumping Stripes",
    "timeLimit": 3, // Total duration in minutes
    "type": "animation_jumping_stripes", // Requires custom animation logic
    "svgPath":
        "assets/images/jumping_stripes/jumping_stripes.png", // Initial image
    "sound": "assets/audio/relaxing_breathing.mp3",
    "benefits": [
      "Enhances eye-hand coordination",
      "Improves focus and concentration"
    ],
    "instructions": [
      {
        "step": 1,
        "instruction": "Follow the moving object carefully.",
        "svgPath": "assets/images/jumping_stripes/jumping_stripes.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 2,
        "instruction":
            "The object will start moving now. Keep your eyes on it.",
        "svgPath":
            "assets/images/mind_chest_breathing.png", // No specific image since the object will move on screen
        "duration": 10 // Remaining time for moving object
      },
    ]
  },

  // Palming
  {
    "title": "Palming",
    "timeLimit": 5, // Total duration in minutes
    "type": "image", // Specifies that this therapy only requires images
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
        "duration": 10 // Duration in seconds
      },
      {
        "step": 2,
        "instruction": "Place your warm palms over your eyes.",
        "svgPath": "assets/images/palming/coverEyes.png",
        "duration": 10 // Duration in seconds
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

  // Kaleidoscope Focus
  {
    "title": "Kaleidoscope Focus",
    "timeLimit": 4, // Total duration in minutes
    "type": "animation_kaleidoscope", // Requires custom animation logic
    "svgPath": "assets/images/kaleidoscope_focus/kaleidoscope.png",
    "sound": "assets/audio/relaxing_breathing.mp3",
    "benefits": [
      "Improves focus and attention",
      "Stimulates visual processing"
    ],
    "instructions": [
      {
        "step": 1,
        "instruction": "Focus on the moving patterns.",
        "svgPath": "assets/images/kaleidoscope_focus/kaleidoscope.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 2,
        "instruction": "",
        "svgPath": "assets/lotties/kaleidoscope.json",
        "duration": 240 // Duration in seconds
      },
    ]
  },

// Yin-Yang Clarity
  {
    "title": "Yin-Yang Clarity",
    "timeLimit": 3, // Total duration in minutes
    "type": "animation_yin_yang", // Requires custom animation logic
    "svgPath": "assets/images/yin_yang_clarity/yin-yang.png",
    "sound": "assets/audio/relaxing_breathing.mp3",
    "benefits": [
      "Balances the mind and body",
      "Enhances focus and mindfulness"
    ],
    "instructions": [
      {
        "step": 1,
        "instruction": "Focus on the Yin-Yang symbol as it enlarges.",
        "svgPath": "assets/images/yin_yang_clarity/yin-yang.png",
        "duration": 5 // Duration in seconds, updated to 5 seconds
      },
      {
        "step": 2,
        "instruction":
            "Watch as the symbol sharpens and rotates, enlarging and shrinking randomly.",
        "svgPath": "assets/images/yin_yang_clarity/yinyang.png",
        "duration":
            175 // Duration for the rest of the therapy period in seconds
      }
    ]
  },

  {
    "title": "Eye Rolling",
    "timeLimit": 2, // Total duration in minutes
    "type":
        "animation_eye_rolling", // Specifies that this therapy requires Rive animation
    "svgPath":
        "assets/images/eye_rolling/eye_rolling.png", // Used for the first step image
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
            "assets/images/eye_rolling/roll_eyes.png", // Image for first step
        "duration":
            10 // Duration in seconds for step 1 before transitioning to the animation
      }
    ]
  },

  // Figure Eight Focus
  {
    "title": "Figure Eight Focus",
    "timeLimit": 3, // Total duration in minutes
    "type":
        "animation_figure_8", // Specifies that this therapy requires animation
    "svgPath":
        "assets/images/figure_eight_focus/figure_eight.png", // Image for step 1
    "sound": "assets/audio/relaxing_breathing.mp3",
    "benefits": ["Enhances visual tracking", "Improves focus and attention"],
    "instructions": [
      {
        "step": 1,
        "instruction": "Follow the loop with your eyes.",
        "svgPath": "assets/images/figure_eight_focus/figure_eight.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 2,
        "instruction": "Now focus on the animated figure eight pattern.",
        "svgPath":
            "assets/images/figure_eight_focus/figure_8.json", // Lottie animation
        "duration": 170 // Duration for the animation in seconds
      }
    ]
  },

  // Distance Gazing
  {
    "title": "Distance Gazing",
    "timeLimit": 2, // Total duration in minutes
    "type": "image", // Specifies that this therapy only requires images
    "svgPath": "assets/images/distance_gazing/distance_gazing.png",
    "sound": "assets/audio/relaxing_breathing.mp3",
    "benefits": [
      "Relieves digital eye strain",
      "Improves eye flexibility",
      "Reduces eye fatigue"
    ],
    "instructions": [
      {
        "step": 1,
        "instruction": "Look at the screen.",
        "svgPath": "assets/images/distance_gazing/distance_gazing.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 2,
        "instruction": "Focus on a ghost far away.",
        "svgPath": "assets/images/distance_gazing/far.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 3,
        "instruction": "focus on the ghost.",
        "svgPath": "assets/images/distance_gazing/near.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 4,
        "instruction": "Close your eyes and relax.",
        "svgPath": "assets/images/distance_gazing/close_eyes.png",
        "duration": 30 // Duration in seconds
      },
      {
        "step": 4,
        "instruction": "Continue this exercise for a minute",
        "svgPath": "assets/images/distance_gazing/distance_gazing.png",
        "duration": 30 // Duration in seconds
      },
    ]
  },

  // Blinking Exercise
  {
    "title": "Blinking Exercise",
    "timeLimit": 2, // Total duration in minutes
    "type": "image", // Specifies that this therapy only requires images
    "svgPath": "assets/images/blinking_exercise/blinking_eye.png",
    "sound": "assets/audio/relaxing_breathing.mp3",
    "benefits": [
      "Lubricates the eyes",
      "Reduces dryness",
      "Prevents eye strain"
    ],
    "instructions": [
      {
        "step": 1,
        "instruction": "Close your eyes gently.",
        "svgPath": "assets/images/blinking_exercise/close_eyes.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 2,
        "instruction": "Open your eyes and blink rapidly.",
        "svgPath": "assets/images/blinking_exercise/blinking.png",
        "duration": 15 // Duration in seconds
      },
      {
        "step": 3,
        "instruction": "Slowly close your eyes again.",
        "svgPath": "assets/images/blinking_exercise/close_eyes.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 4,
        "instruction": "Repeat the blinking exercise.",
        "svgPath": "assets/images/blinking_exercise/blinking.png",
        "duration": 15 // Duration in seconds
      },
      {
        "step": 5,
        "instruction": "Relax and breathe deeply.",
        "svgPath": "assets/images/blinking_exercise/exhaling.png",
        "duration": 20 // Duration in seconds
      },
    ]
  },

  // Focus Shifting
  {
    "title": "Focus Shifting",
    "timeLimit": 3, // Total duration in minutes
    "type": "image", // Specifies that this therapy only requires images
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
        "duration": 20 // Duration in seconds
      },
      {
        "step": 2,
        "instruction": "Focus on your thumb for a few seconds.",
        "svgPath": "assets/images/focus_shifting/focus_thumb.png",
        "duration": 30 // Duration in seconds
      },
      {
        "step": 3,
        "instruction": "Shift your focus to something farther away.",
        "svgPath": "assets/images/distance_gazing/far.png",
        "duration": 30 // Duration in seconds
      },
      {
        "step": 4,
        "instruction": "Shift your focus back to your thumb.",
        "svgPath": "assets/images/focus_shifting/focus_thumb.png",
        "duration": 30 // Duration in seconds
      },
      {
        "step": 5,
        "instruction": "Repeat the focus shifting.",
        "svgPath": "assets/images/focus_shifting/thumb.png",
        "duration": 30 // Duration in seconds
      },
    ]
  },
];
