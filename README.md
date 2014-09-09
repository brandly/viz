# viz

put an `audio` element and a `canvas` element inside something with an `id`
```html
<div id="viz">
  <audio preload="auto" src="04 - Guns &amp; Roses.mp3" controls autoplay></audio>
  <canvas></canvas>
</div>
```

and define how to draw a frame, given information about that particular point in the audio
```javascript
new Viz('viz', {
  frequency: function (frequencyData, context, canvas) {
    // draw a frame
  },
  time: function (timeData, context, canvas) {
    // draw a frame
  }
});
```

checkout [the demo](http://brandly.github.io/viz/)
