final List<Map<String, dynamic>> bulgyEyeTherapies = [
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

  // Squint Exercise
  {
    "title": "Squint",
    "timeLimit": 3, // Total duration in minutes
    "type": "instruction", // Specifies that this therapy is instructional
    "svgPath": "assets/images/bulgy_eyes/squint/squint.png",
    "sound": "assets/audio/eye_squint.mp3",
    "benefits": ["Strengthens eye muscles", "Reduces eye strain"],
    "instructions": [
      {
        "step": 1,
        "instruction":
            "Squint your eyes gently as if you are trying to focus on a distant object.",
        "svgPath": "assets/images/bulgy_eyes/squint/close_eyes.png",
        "duration": 5 // Duration in seconds
      },
      {
        "step": 2,
        "instruction": "Hold the squint for 5 seconds.",
        "svgPath": "assets/images/bulgy_eyes/squint/close_eyes.png",
        "duration": 5 // Duration in seconds
      },
      {
        "step": 3,
        "instruction": "Relax your eyes and blink a few times.",
        "svgPath": "assets/images/bulgy_eyes/squint/final.png",
        "duration": 5 // Duration in seconds
      },
      {
        "step": 4,
        "instruction": "Repeat the squint-relax cycle for 3 minutes.",
        "svgPath": "assets/images/bulgy_eyes/squint/final.png",
        "duration": 180 // Duration in seconds
      }
    ]
  },

  // Eye Direction
  {
    "title": "Eye Direction and Relaxation",
    "timeLimit": 3, // Total duration in minutes
    "type": "instruction", // Specifies that this therapy is instructional
    "svgPath": "assets/images/bulgy_eyes/eye_direction/eye_direction.png",
    "sound": "assets/audio/eye_direction.mp3",
    "benefits": [
      "Improves eye coordination",
      "Relieves eye strain",
      "Enhances focus"
    ],
    "instructions": [
      {
        "step": 1,
        "instruction":
            "Look up as far as you can while keeping your head still.",
        "svgPath": "assets/images/bulgy_eyes/eye_direction/up.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 2,
        "instruction": "Now slowly look down, focusing on your toes.",
        "svgPath": "assets/images/bulgy_eyes/eye_direction/down.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 3,
        "instruction":
            "Look to the left, trying to see as far as possible without moving your head.",
        "svgPath": "assets/images/bulgy_eyes/eye_direction/left.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 4,
        "instruction": "Look to the right, keeping your head still.",
        "svgPath": "assets/images/bulgy_eyes/eye_direction/right.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 5,
        "instruction": "Close your eyes gently and relax.",
        "svgPath": "assets/images/bulgy_eyes/eye_direction/close.png",
        "duration": 20 // Duration in seconds
      }
    ]
  },

  // Clockwise Eye Movement
  {
    "title": "Clockwise Eye Movement",
    "timeLimit": 2, // Total duration in minutes
    "type": "instruction", // Specifies that this therapy is instructional
    "svgPath": "assets/images/bulgy_eyes/rotate/rotate.png",
    "sound": "assets/audio/rotate.mp3",
    "benefits": ["Enhances eye flexibility", "Improves coordination"],
    "instructions": [
      {
        "step": 1,
        "instruction":
            "Look straight ahead and slowly move your eyes in a circular motion clockwise.",
        "svgPath": "assets/images/bulgy_eyes/rotate/clockwise.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 2,
        "instruction": "Complete 4 full rotations clockwise.",
        "svgPath": "assets/images/bulgy_eyes/rotate/clockwise.png",
        "duration": 20 // Duration in seconds
      },
      {
        "step": 3,
        "instruction":
            "Now slowly move your eyes in a counterclockwise motion.",
        "svgPath": "assets/images/bulgy_eyes/rotate/counter_clockwise.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 4,
        "instruction": "Complete 4 full rotations counterclockwise.",
        "svgPath": "assets/images/bulgy_eyes/rotate/counter_clockwise.png",
        "duration": 20 // Duration in seconds
      }
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
  }
];
