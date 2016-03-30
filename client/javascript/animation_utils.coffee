define("animation_utils", [], () ->

    R = (max,min) ->
        return Math.random()*(max-min)+min

    # Shake = (element, shakes, timeScale, xScale, yScale, rotationScale) ->
    #     tl = new TimelineLite();
    #     TweenLite.set(element, {x:"+=0"})
    #     transforms = element._gsTransform;
        
    #     initProps = {
    #         x:0,
    #         y:0,
    #         rotation:0
    #     }
    #     for i in [0..shakes]
    #         tl.to(element, timeScale ,{x:initProps.x + R(-xScale, xScale), y:initProps.y + R(-yScale, yScale), rotation:initProps.rotation + R(-rotationScale, rotationScale)})
    #     tl.to(element, timeScale ,{x:initProps.x, y:initProps.y, scale:initProps.scale, rotation:initProps.rotation})
    #     return tl

    Shake = (element, shakes, timeScale, xScale, yScale) ->
        tl = new TimelineLite();
        TweenLite.set(element, {x:"+=0"})
        transforms = element._gsTransform;
        
        initProps = {
            x:0,
            y:0,
            rotation:0
        }
        for i in [0..shakes]
            tl.to(element, timeScale ,{x:initProps.x + R(-xScale, xScale), y:initProps.y + R(-yScale, yScale)})
        tl.to(element, timeScale ,{x:initProps.x, y:initProps.y, scale:initProps.scale})
        return tl

    Thump = (element, attribute, inTime, outTime, value, endValue) ->
        tl = new TimelineLite()
        if endValue? == false
            endValue = element.css(attribute)
        tl
            .to(element[0], inTime, {
                "#{attribute}": value

            })
            .to(element[0], outTime, {
                "#{attribute}": endValue
            })



    return {
        R: R
        Shake: Shake
        Thump: Thump
    }
)