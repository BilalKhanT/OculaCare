final List<Map<String, dynamic>> crossedEyeTherapies = [
  // Brock String Exercise
  {
    "title": "Brock String Exercise",
    "timeLimit": 10, // Total duration in minutes
    "type": "animation_string", // Specifies that this therapy is instructional
    "svgPath": "assets/images/crossed_eyes/brock_string/brock_string.png",
    "sound": "assets/audio/relaxing_breathing.mp3",
    "benefits": ["Improves eye alignment", "Strengthens eye coordination"],
    "instructions": [
      {
        "step": 1,
        "instruction":
            "Look at the string with three beads by placing the phone in front of your nose.",
        "svgPath": "assets/images/crossed_eyes/brock_string/brock_string.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 2,
        "instruction":
            "Focus on the nearest bead, then shift to the middle, and then the farthest bead.",
        "svgPath": "",
        "duration": 30 // Duration in seconds
      },
      {
        "step": 3,
        "instruction": "Ensure both eyes are focusing on the same bead.",
        "svgPath": "",
        "duration": 30 // Duration in seconds
      }
    ]
  },

  // Mirror Eye Stretch
  {
    "title": "Mirror Eye Stretch",
    "timeLimit": 5, // Total duration in minutes
    "type": "instruction", // Specifies that this therapy is instructional
    "svgPath": "assets/images/crossed_eyes/mirror_eye/mirror_eye.png",
    "sound": "assets/audio/relaxing_breathing.mp3",
    "benefits": ["Strengthens eye muscles", "Improves coordination"],
    "instructions": [
      {
        "step": 1,
        "instruction":
            "Look at the screen and cover your dominant eye and follow the object.",
        "svgPath": "assets/images/crossed_eyes/mirror_eye/coverEyes.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 2,
        "instruction":
            "Move your gaze left, right, up, and down while focusing on your reflection.",
        "svgPath": "assets/images/crossed_eyes/mirror_eye/bg.png",
        "duration": 20 // Duration in seconds
      },
      {
        "step": 3,
        "instruction": "Alternate between covering each eye and repeat.",
        "svgPath": "assets/images/crossed_eyes/mirror_eye/bg.png",
        "duration": 20 // Duration in seconds
      }
    ]
  },

  // Pencil Push-Up Therapy
  {
    "title": "Pencil Push-Up",
    "timeLimit": 10, // Total duration in minutes
    "type": "instruction", // Specifies that this therapy is instructional
    "svgPath": "assets/images/crossed_eyes/pencil_pushups/pencil_pushups.png",
    "sound": "assets/audio/relaxing_breathing.mp3",
    "benefits": ["Improves focus", "Strengthens eye coordination"],
    "instructions": [
      {
        "step": 1,
        "instruction": "Hold a pencil at arm's length in front of your nose.",
        "svgPath":
            "assets/images/crossed_eyes/pencil_pushups/pencil_pushups.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 2,
        "instruction":
            "Slowly move the pencil closer, keeping your focus on it.",
        "svgPath":
            "assets/images/crossed_eyes/pencil_pushups/bring_pencil_closer.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 3,
        "instruction": "Stop when the pencil becomes blurry or you see double.",
        "svgPath":
            "assets/images/crossed_eyes/pencil_pushups/stop_when_blurry.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 4,
        "instruction": "Move the pencil back to arm's length and repeat.",
        "svgPath":
            "assets/images/crossed_eyes/pencil_pushups/pencil_pushups.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 4,
        "instruction": "continue this exercise for a minute.",
        "svgPath":
            "assets/images/crossed_eyes/pencil_pushups/pencil_pushups.png",
        "duration": 60 // Duration in seconds
      }
    ]
  },

  // Barrel Card Exercise
  {
    "title": "Barrel Card Exercise",
    "timeLimit": 5, // Total duration in minutes
    "type": "animation_barrel", // Specifies that this therapy is instructional
    "svgPath": "assets/images/crossed_eyes/barrel_card/barrel_card.png",
    "sound": "assets/audio/relaxing_breathing.mp3",
    "benefits": ["Improves eye convergence", "Strengthens eye coordination"],
    "instructions": [
      {
        "step": 1,
        "instruction":
            "Look at the card with three barrels in front of your nose.",
        "svgPath": "assets/images/crossed_eyes/barrel_card/barrel_bg.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 2,
        "instruction": "Focus on the largest barrel.",
        "svgPath": "assets/images/crossed_eyes/barrel_card/largest.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 3,
        "instruction": "Focus on the middle.",
        "svgPath": "assets/images/crossed_eyes/barrel_card/middle.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 4,
        "instruction": "Focus on the smallest.",
        "svgPath": "assets/images/crossed_eyes/barrel_card/smallest.png",
        "duration": 10 // Duration in seconds
      },
      {
        "step": 5,
        "instruction":
            "Move the card away from your nose while focusing on the barrels.",
        "svgPath": "assets/images/crossed_eyes/barrel_card/barrel_bg.png",
        "duration": 10 // Duration in seconds
      }
    ]
  },

  // Eye Patch Therapy
  {
    "title": "Eye Patch Therapy",
    "timeLimit": 1, // Total duration in minutes
    "type": "instruction", // Specifies that this therapy is instructional
    "svgPath": "assets/images/crossed_eyes/eye_patch/eye_patch.png",
    "sound": "assets/audio/relaxing_breathing.mp3",
    "benefits": ["Strengthens the weaker eye", "Improves coordination"],
    "instructions": [
      {
        "step": 1,
        "instruction": "Cover your stronger eye with an eye patch.",
        "svgPath": "assets/images/crossed_eyes/eye_patch/eye_patch.png",
        "duration":
            5 // Duration in seconds (this could vary based on recommendations)
      },
      {
        "step": 2,
        "instruction": "Use your weaker eye to read the text.",
        "svgPath": "assets/images/crossed_eyes/eye_patch/read.png",
        "duration": 45 // Duration in seconds
      }
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
