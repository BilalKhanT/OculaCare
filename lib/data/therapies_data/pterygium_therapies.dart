final List<Map<String, dynamic>> pterygiumTherapies = [
  // Cold Compress
  {
    "title": "Cold Compress",
    "timeLimit": 5,
    "type": "instruction",
    "svgPath": "assets/images/pterygium/cold_compress/cold_compress.png",
    "sound": "assets/audio/relaxing_breathing.mp3",
    "benefits": [
      "Reduces redness and swelling",
      "Soothes irritated eyes",
      "Provides relief from discomfort"
    ],
    "instructions": [
      {
        "step": 1,
        "instruction": "Place a cold compress gently over your closed eyes.",
        "svgPath":
            "assets/images/pterygium/cold_compress/cold_compress_eyes.png",
        "duration": 120 // Duration in seconds
      },
      {
        "step": 2,
        "instruction":
            "Relax and breathe deeply while keeping the cold compress in place.",
        "svgPath": "assets/images/pterygium/cold_compress/close_eyes.png",
        "duration": 180 // Duration in seconds
      }
    ]
  },

  // Eye Massage
  {
    "title": "Eye Massage",
    "timeLimit": 5,
    "type": "instruction",
    "svgPath": "assets/images/pterygium/eye_message/eye_message.png",
    "sound": "assets/audio/relaxing_breathing.mp3",
    "benefits": [
      "Relieves eye tension",
      "Improves blood circulation around the eyes",
      "Reduces puffiness"
    ],
    "instructions": [
      {
        "step": 1,
        "instruction":
            "Close your eyes and gently massage your eyelids in circular motions.",
        "svgPath": "assets/images/pterygium/eye_message/message_circular.png",
        "duration": 120 // Duration in seconds
      },
      {
        "step": 2,
        "instruction":
            "Use light pressure and slowly move your fingers around the eye socket.",
        "svgPath": "assets/images/pterygium/eye_message/eye_message_around.png",
        "duration": 120 // Duration in seconds
      }
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

  // Eye Direction
  {
    "title": "Eye Direction and Relaxation",
    "timeLimit": 3, // Total duration in minutes
    "type": "instruction", // Specifies that this therapy is instructional
    "svgPath": "assets/images/bulgy_eyes/eye_direction/eye_direction.png",
    "sound": "assets/audio/relaxing_breathing.mp3",
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

  // Peripheral Awareness Exercise
  {
    "title": "Peripheral Awareness Exercise",
    "timeLimit": 5, // Total duration in minutes
    "type":
        "animation_peripheral", // Specifies that this therapy is instructional
    "svgPath": "assets/images/crossed_eyes/peripheral_awareness/peripheral.png",
    "sound": "assets/audio/relaxing_breathing.mp3",
    "benefits": ["Strengthens peripheral vision", "Improves coordination"],
    "instructions": [
      {
        "step": 1,
        "instruction":
            "Hold your phone in landscape and look at the person in the center.",
        "svgPath": "assets/images/crossed_eyes/peripheral_awareness/step01.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 2,
        "instruction":
            "Without moving your head, shift your gaze left, right, up, and down.",
        "svgPath": "assets/images/crossed_eyes/peripheral_awareness/step02.png",
        "duration": 20 // Duration in seconds
      }
    ]
  }
];
