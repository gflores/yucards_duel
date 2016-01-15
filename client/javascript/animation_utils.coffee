define("animation_utils", [], () ->

    R = (max,min) ->
        return Math.random()*(max-min)+min

    Shake = (element, shakes, timeScale, xScale, yScale, rotationScale) ->
        tl = new TimelineLite();
        TweenLite.set(element, {x:"+=0"})
        transforms = element._gsTransform;
        
        initProps = {
            x:0,
            y:0,
            rotation:0
        }
        for i in [0..shakes]
            tl.to(element, timeScale ,{x:initProps.x + R(-xScale, xScale), y:initProps.y + R(-yScale, yScale), rotation:initProps.rotation + R(-rotationScale, rotationScale)})
        tl.to(element, timeScale ,{x:initProps.x, y:initProps.y, scale:initProps.scale, rotation:initProps.rotation})
        return tl

    return {
        R: R
        Shake: Shake
    }
)