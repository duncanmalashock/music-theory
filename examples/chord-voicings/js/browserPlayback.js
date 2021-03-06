export { browserPlaybackInit }

import WebAudioFontPlayer from "webaudiofont";

const browserPlaybackInit = function(app) {
  // Initialize player object
  const AudioContextFunc = window.AudioContext || window.webkitAudioContext;
  const audioContext = new AudioContextFunc();
  const player = new WebAudioFontPlayer();

  let instrumentsDict = {};

  app.ports.loadInstrumentById.subscribe(function(instrumentId) {
    const instrumentInfo = player.loader.instrumentInfo(instrumentId);
    instrumentsDict[instrumentId] = instrumentInfo
    player.loader.startLoad(audioContext, instrumentInfo.url, instrumentInfo.variable);
  })

  app.ports.play.subscribe(function(events) {
    player.loader.waitLoad(function () {
      player.cancelQueue(audioContext);
      const startTime = audioContext.currentTime;
      events.forEach(function(event) {
        const time = startTime + event.time;
        player.queueWaveTable(
          audioContext,
          audioContext.destination,
          window[instrumentsDict[event.instrumentId].variable],
          time,
          event.pitch,
          event.duration,
          (event.volume / 127)
        )
      })
    });
    return false
  });
};
