export module my_avnd_effect;
import halp;

export namespace Example
{
class MyAvndEffect
{
public:
  static consteval auto name() { return  "My Avendish Gain"; }
  static consteval auto c_name() { return  "my_avnd_effect"; }
  static consteval auto category() { return  "Audio"; }
  static consteval auto uuid() { return  "00000000-0000-0000-0000-000000000000"; }

  // Define inputs and outputs ports.
  // See the docs at https://github.com/celtera/avendish
  struct ins
  {
    halp::dynamic_audio_bus<"Input", double> audio;
    halp::knob_f32<"Weight", halp::range{.min = 0., .max = 10., .init = 0.5}> gain;
  } inputs;

  struct
  {
    halp::dynamic_audio_bus<"Output", double> audio;
  } outputs;

  using setup = halp::setup;
  void prepare(halp::setup info)
  {
    // Initialization, this method will be called with buffer size, etc.
  }

  // Do our processing for N samples
  using tick = halp::tick;

  // Defined in the .cpp
  void operator()(halp::tick t);
};

}

module :private;

namespace Example
{
void MyAvndEffect::operator()(halp::tick t)
{
  // Process the input buffer
  for(int i = 0; i < inputs.audio.channels; i++)
  {
    auto* in = inputs.audio[i];
    auto* out = outputs.audio[i];

    for(int j = 0; j < t.frames; j++)
    {
      out[j] = inputs.gain * in[j] + 2;
    }
  }
}
}
