id = '5dc62fa6-e965-45cb-a0da-e87d29713117'
name = 'Color Swirls (Perlin): Blue and Red'
description = 'Color Swirl effect'
active_scripts = [
    'swirl-perlin.lua',
    'shockwave.lua',
#    'impact.lua',
#   'water.lua',
#   'raindrops.lua',
    'macros.lua',
#   'stats.lua',
#   'profiles.lua',
]

[[config."Perlin Swirl"]]
type = 'float'
name = 'color_divisor'
value = 2.0

[[config."Perlin Swirl"]]
type = 'float'
name = 'color_offset'
value = 160.0

[[config.Shockwave]]
type = 'color'
name = 'color_step_shockwave'
value = 0x05010000

[[config.Shockwave]]
type = 'bool'
name = 'mouse_events'
value = true

[[config.Shockwave]]
type = 'color'
name = 'color_mouse_click_flash'
value = 0xa0ff0000

[[config.Shockwave]]
type = 'color'
name = 'color_mouse_wheel_flash'
value = 0xd0ff0000

[[config.Raindrops]]
type = 'float'
name = 'opacity'
value = 0.75
