-- WirePlumber policy for Qualcomm Q6DSP on Snapdragon X Elite
-- /usr/share/wireplumber/main.lua.d/91-surface-arm64-qcom.lua

rule = {
  matches = {
    { { "node.name", "matches", "alsa_output.platform*sc8280xp*" } },
  },
  apply_properties = {
    ["audio.rate"] = 48000,
    ["audio.format"] = "S16LE",
    ["resample.quality"] = 4,
    ["priority.session"] = 1100,
  },
}
