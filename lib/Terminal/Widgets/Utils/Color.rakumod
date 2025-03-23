# ABSTRACT: Simple color utility routines

unit module Terminal::Widgets::Utils::Color;

our @indexed_256 is export = (
  [ '#000000', 'black'                      ],
  [ '#800000', 'maroon'                     ],
  [ '#008000', 'office_green'               ],
  [ '#808000', 'yellow_003'                 ],
  [ '#000080', 'blue_004'                   ],
  [ '#800080', 'patriarch'                  ],
  [ '#008080', 'cyan_006'                   ],
  [ '#c0c0c0', 'argent'                     ],
  [ '#808080', 'gray'                       ],
  [ '#ff0000', 'light_red'                  ],
  [ '#00ff00', 'electric_green'             ],
  [ '#ffff00', 'light_yellow_011'           ],
  [ '#0000ff', 'blue'                       ],
  [ '#ff00ff', 'fuchsia'                    ],
  [ '#00ffff', 'aqua'                       ],
  [ '#ffffff', 'light_white'                ],
  [ '#000000', 'black'                      ],
  [ '#00005f', 'fuzzy_wuzzy'                ],
  [ '#000087', 'dark_blue'                  ],
  [ '#0000af', 'carnation_pink'             ],
  [ '#0000d7', 'medium_blue'                ],
  [ '#0000ff', 'blue'                       ],
  [ '#005f00', 'camarone'                   ],
  [ '#005f5f', 'bangladesh_green'           ],
  [ '#005f87', 'orient'                     ],
  [ '#005faf', 'endeavour'                  ],
  [ '#005fd7', 'science_blue'               ],
  [ '#005fff', 'blue_ribbon'                ],
  [ '#008700', 'ao'                         ],
  [ '#00875f', 'deep_sea'                   ],
  [ '#008787', 'teal'                       ],
  [ '#0087af', 'deep_cerulean'              ],
  [ '#0087d7', 'blue_cola'                  ],
  [ '#0087ff', 'azure'                      ],
  [ '#00af00', 'dark_lime_green'            ],
  [ '#00af5f', 'go_green'                   ],
  [ '#00af87', 'dark_cyan'                  ],
  [ '#00afaf', 'bondi_blue'                 ],
  [ '#00afd7', 'cerulean'                   ],
  [ '#00afff', 'blue_bolt'                  ],
  [ '#00d700', 'strong_lime_green'          ],
  [ '#00d75f', 'malachite'                  ],
  [ '#00d787', 'caribbean_green_042'        ],
  [ '#00d7af', 'caribbean_green'            ],
  [ '#00d7d7', 'dark_turquoise'             ],
  [ '#00d7ff', 'vivid_sky_blue'             ],
  [ '#00ff00', 'electric_green'             ],
  [ '#00ff5f', 'spring_green_047'           ],
  [ '#00ff87', 'guppie_green'               ],
  [ '#00ffaf', 'medium_spring_green'        ],
  [ '#00ffd7', 'bright_turquoise'           ],
  [ '#00ffff', 'aqua'                       ],
  [ '#5f0000', 'blood_red'                  ],
  [ '#5f005f', 'imperial_purple'            ],
  [ '#5f0087', 'metallic_violet'            ],
  [ '#5f00af', 'chinese_purple'             ],
  [ '#5f00d7', 'electric_violet_056'        ],
  [ '#5f00ff', 'electric_indigo'            ],
  [ '#5f5f00', 'bronze_yellow'              ],
  [ '#5f5f5f', 'scorpion'                   ],
  [ '#5f5f87', 'comet'                      ],
  [ '#5f5faf', 'dark_moderate_blue'         ],
  [ '#5f5fd7', 'indigo'                     ],
  [ '#5f5fff', 'cornflower_blue'            ],
  [ '#5f8700', 'avocado'                    ],
  [ '#5f875f', 'glade_green'                ],
  [ '#5f8787', 'juniper'                    ],
  [ '#5f87af', 'hippie_blue'                ],
  [ '#5f87d7', 'havelock_blue'              ],
  [ '#5f87ff', 'blueberry'                  ],
  [ '#5faf00', 'dark_green'                 ],
  [ '#5faf5f', 'dark_moderate_lime_green'   ],
  [ '#5faf87', 'polished_pine'              ],
  [ '#5fafaf', 'crystal_blue'               ],
  [ '#5fafd7', 'aqua_pearl'                 ],
  [ '#5fafff', 'blue_jeans'                 ],
  [ '#5fd700', 'alien_armpit'               ],
  [ '#5fd75f', 'moderate_lime_green'        ],
  [ '#5fd787', 'caribbean_green_pearl'      ],
  [ '#5fd7af', 'downy'                      ],
  [ '#5fd7d7', 'medium_turquoise'           ],
  [ '#5fd7ff', 'maya_blue'                  ],
  [ '#5fff00', 'bright_green'               ],
  [ '#5fff5f', 'light_lime_green'           ],
  [ '#5fff87', 'very_light_malachite_green' ],
  [ '#5fffaf', 'medium_aquamarine'          ],
  [ '#5fffd7', 'aquamarine_086'             ],
  [ '#5fffff', 'aquamarine_087'             ],
  [ '#870000', 'deep_red'                   ],
  [ '#87005f', 'french_plum'                ],
  [ '#870087', 'fresh_eggplant'             ],
  [ '#8700af', 'purple'                     ],
  [ '#8700d7', 'french_violet'              ],
  [ '#8700ff', 'electric_violet'            ],
  [ '#875f00', 'brown'                      ],
  [ '#875f5f', 'copper_rose'                ],
  [ '#875f87', 'chinese_violet'             ],
  [ '#875faf', 'dark_moderate_violet'       ],
  [ '#875fd7', 'medium_purple'              ],
  [ '#875fff', 'blueberry_099'              ],
  [ '#878700', 'dark_yellow_olive_tone'     ],
  [ '#87875f', 'clay_creek'                 ],
  [ '#878787', 'taupe_gray'                 ],
  [ '#8787af', 'cool_grey'                  ],
  [ '#8787d7', 'chetwode_blue'              ],
  [ '#8787ff', 'violets_are_blue'           ],
  [ '#87af00', 'apple_green'                ],
  [ '#87af5f', 'asparagus'                  ],
  [ '#87af87', 'bay_leaf'                   ],
  [ '#87afaf', 'dark_grayish_cyan'          ],
  [ '#87afd7', 'light_cobalt_blue'          ],
  [ '#87afff', 'french_sky_blue'            ],
  [ '#87d700', 'pistachio'                  ],
  [ '#87d75f', 'mantis'                     ],
  [ '#87d787', 'pastel_green'               ],
  [ '#87d7af', 'pearl_aqua'                 ],
  [ '#87d7d7', 'bermuda'                    ],
  [ '#87d7ff', 'pale_cyan'                  ],
  [ '#87ff00', 'chartreuse'                 ],
  [ '#87ff5f', 'light_green'                ],
  [ '#87ff87', 'very_light_lime_green'      ],
  [ '#87ffaf', 'mint_green_121'             ],
  [ '#87ffd7', 'aquamarine'                 ],
  [ '#87ffff', 'anakiwa'                    ],
  [ '#af0000', 'bright_red'                 ],
  [ '#af005f', 'dark_pink'                  ],
  [ '#af0087', 'dark_magenta'               ],
  [ '#af00af', 'heliotrope_magenta'         ],
  [ '#af00d7', 'vivid_mulberry'             ],
  [ '#af00ff', 'electric_purple'            ],
  [ '#af5f00', 'dark_orange_brown_tone'     ],
  [ '#af5f5f', 'dark_moderate_red'          ],
  [ '#af5f87', 'dark_moderate_pink'         ],
  [ '#af5faf', 'dark_moderate_magenta'      ],
  [ '#af5fd7', 'rich_lilac'                 ],
  [ '#af5fff', 'lavender_indigo'            ],
  [ '#af8700', 'dark_goldenrod'             ],
  [ '#af875f', 'bronze'                     ],
  [ '#af8787', 'dark_grayish_red'           ],
  [ '#af87af', 'bouquet'                    ],
  [ '#af87d7', 'lavender'                   ],
  [ '#af87ff', 'bright_lavender'            ],
  [ '#afaf00', 'buddha_gold'                ],
  [ '#afaf5f', 'dark_moderate_yellow'       ],
  [ '#afaf87', 'dark_grayish_yellow'        ],
  [ '#afafaf', 'silver_foil'                ],
  [ '#afafd7', 'grayish_blue'               ],
  [ '#afafff', 'maximum_blue_purple'        ],
  [ '#afd700', 'rio_grande'                 ],
  [ '#afd75f', 'conifer'                    ],
  [ '#afd787', 'feijoa'                     ],
  [ '#afd7af', 'grayish_lime_green'         ],
  [ '#afd7d7', 'crystal'                    ],
  [ '#afd7ff', 'fresh_air'                  ],
  [ '#afff00', 'lime'                       ],
  [ '#afff5f', 'green_yellow'               ],
  [ '#afff87', 'mint_green'                 ],
  [ '#afffaf', 'menthol'                    ],
  [ '#afffd7', 'aero_blue'                  ],
  [ '#afffff', 'celeste'                    ],
  [ '#d70000', 'guardsman_red'              ],
  [ '#d7005f', 'razzmatazz'                 ],
  [ '#d70087', 'mexican_pink'               ],
  [ '#d700af', 'hollywood_cerise_163'       ],
  [ '#d700d7', 'deep_magenta'               ],
  [ '#d700ff', 'phlox'                      ],
  [ '#d75f00', 'strong_orange'              ],
  [ '#d75f5f', 'indian_red'                 ],
  [ '#d75f87', 'blush'                      ],
  [ '#d75faf', 'hopbush'                    ],
  [ '#d75fd7', 'moderate_magenta'           ],
  [ '#d75fff', 'heliotrope'                 ],
  [ '#d78700', 'chocolate'                  ],
  [ '#d7875f', 'copperfield'                ],
  [ '#d78787', 'my_pink'                    ],
  [ '#d787af', 'can_can'                    ],
  [ '#d787d7', 'deep_mauve'                 ],
  [ '#d787ff', 'bright_lilac'               ],
  [ '#d7af00', 'goldenrod'                  ],
  [ '#d7af5f', 'earth_yellow'               ],
  [ '#d7af87', 'slightly_desaturated_orange'],
  [ '#d7afaf', 'clam_shell'                 ],
  [ '#d7afd7', 'grayish_magenta'            ],
  [ '#d7afff', 'mauve'                      ],
  [ '#d7d700', 'citrine'                    ],
  [ '#d7d75f', 'chinese_green'              ],
  [ '#d7d787', 'deco'                       ],
  [ '#d7d7af', 'grayish_yellow'             ],
  [ '#d7d7d7', 'light_silver'               ],
  [ '#d7d7ff', 'fog'                        ],
  [ '#d7ff00', 'chartreuse_yellow'          ],
  [ '#d7ff5f', 'canary'                     ],
  [ '#d7ff87', 'honeysuckle'                ],
  [ '#d7ffaf', 'pale_green'                 ],
  [ '#d7ffd7', 'beige'                      ],
  [ '#d7ffff', 'light_cyan'                 ],
  [ '#ff0000', 'light_red'                  ],
  [ '#ff005f', 'vivid_raspberry'            ],
  [ '#ff0087', 'bright_pink'                ],
  [ '#ff00af', 'fashion_fuchsia'            ],
  [ '#ff00d7', 'pure_magenta'               ],
  [ '#ff00ff', 'fuchsia'                    ],
  [ '#ff5f00', 'blaze_orange'               ],
  [ '#ff5f5f', 'bittersweet'                ],
  [ '#ff5f87', 'strawberry'                 ],
  [ '#ff5faf', 'hot_pink'                   ],
  [ '#ff5fd7', 'light_deep_pink'            ],
  [ '#ff5fff', 'pink_flamingo'              ],
  [ '#ff8700', 'american_orange'            ],
  [ '#ff875f', 'coral'                      ],
  [ '#ff8787', 'tulip'                      ],
  [ '#ff87af', 'pink_salmon'                ],
  [ '#ff87d7', 'lavender_rose'              ],
  [ '#ff87ff', 'blush_pink'                 ],
  [ '#ffaf00', 'chinese_yellow'             ],
  [ '#ffaf5f', 'light_orange'               ],
  [ '#ffaf87', 'hit_pink'                   ],
  [ '#ffafaf', 'melon'                      ],
  [ '#ffafd7', 'cotton_candy'               ],
  [ '#ffafff', 'pale_magenta'               ],
  [ '#ffd700', 'gold'                       ],
  [ '#ffd75f', 'dandelion'                  ],
  [ '#ffd787', 'grandis'                    ],
  [ '#ffd7af', 'caramel'                    ],
  [ '#ffd7d7', 'cosmos'                     ],
  [ '#ffd7ff', 'bubble_gum'                 ],
  [ '#ffff00', 'light_yellow_011'           ],
  [ '#ffff5f', 'laser_lemon'                ],
  [ '#ffff87', 'dolly'                      ],
  [ '#ffffaf', 'calamansi'                  ],
  [ '#ffffd7', 'cream'                      ],
  [ '#ffffff', 'light_white'                ],
  [ '#080808', 'vampire_black'              ],
  [ '#121212', 'chinese_black'              ],
  [ '#1c1c1c', 'eerie_black'                ],
  [ '#262626', 'raisin_black'               ],
  [ '#303030', 'dark_charcoal'              ],
  [ '#3a3a3a', 'black_olive'                ],
  [ '#444444', 'outer_space'                ],
  [ '#4e4e4e', 'dark_liver'                 ],
  [ '#585858', 'davys_grey'                 ],
  [ '#626262', 'granite_gray'               ],
  [ '#6c6c6c', 'dim_gray'                   ],
  [ '#767676', 'boulder'                    ],
  [ '#808080', 'gray'                       ],
  [ '#8a8a8a', 'philippine_gray'            ],
  [ '#949494', 'dusty_gray'                 ],
  [ '#9e9e9e', 'spanish_gray'               ],
  [ '#a8a8a8', 'dark_gray'                  ],
  [ '#b2b2b2', 'philippine_silver'          ],
  [ '#bcbcbc', 'silver'                     ],
  [ '#c6c6c6', 'silver_sand'                ],
  [ '#d0d0d0', 'american_silver'            ],
  [ '#dadada', 'alto'                       ],
  [ '#e4e4e4', 'mercury'                    ],
  [ '#eeeeee', 'bright_gray'                ]
);

#| Convert an rgb triplet (each in the 0..1 range) to a valid cell color
multi rgb-color-flat(Real:D $r, Real:D $g, Real:D $b) is export {
    # Just use the 6x6x6 color cube, ignoring the hi-res gray ramp.
    # NOTE: Ignores uneven spacing of xterm-256 color cube for speed.

    ~(16 + 36 * (my int $ri = floor(5e0 * (my num $rn = $r.Num) + .5e0))
         +  6 * (my int $gi = floor(5e0 * (my num $gn = $g.Num) + .5e0))
         +      (my int $bi = floor(5e0 * (my num $bn = $b.Num) + .5e0)))
}


#| Convert an rgb triplet (each in the 0..1 range) to a valid cell color
multi rgb-color-flat(num $r, num $g, num $b) is export {
    # Just use the 6x6x6 color cube, ignoring the hi-res gray ramp.
    # NOTE: Ignores uneven spacing of xterm-256 color cube for speed.

    ~(16 + 36 * (my int $ri = floor(5e0 * $r + .5e0))
         +  6 * (my int $gi = floor(5e0 * $g + .5e0))
         +      (my int $bi = floor(5e0 * $b + .5e0)))
}


#| Convert an rgb triplet (each in the 0..1 range) to a valid cell color
multi rgb-color(Real:D $r, Real:D $g, Real:D $b) is export {
    # Just use the 6x6x6 color cube, ignoring the hi-res gray ramp.

    # NOTE: The xterm-256 color cube is *NOT* evenly spaced along the axes;
    #       rather, there is a very large jump between black and the first
    #       visible color in each primary, and smaller jumps thereafter.

    ~(16 + 36 * (my int $ri = (my num $rn = $r.Num) < .45098e0
                              ?? my int $rc = $rn >= .1875e0
                              !! my int $rf = floor(6.375e0 * $rn - .875e0))
         +  6 * (my int $gi = (my num $gn = $g.Num) < .45098e0
                              ?? my int $gc = $gn >= .1875e0
                              !! my int $gf = floor(6.375e0 * $gn - .875e0))
         +      (my int $bi = (my num $bn = $b.Num) < .45098e0
                              ?? my int $bc = $bn >= .1875e0
                              !! my int $bf = floor(6.375e0 * $bn - .875e0)))
}


#| Convert an rgb triplet (each in the 0..1 range) to a valid cell color
multi rgb-color(num $r, num $g, num $b) is export {
    # Just use the 6x6x6 color cube, ignoring the hi-res gray ramp.

    # NOTE: The xterm-256 color cube is *NOT* evenly spaced along the axes;
    #       rather, there is a very large jump between black and the first
    #       visible color in each primary, and smaller jumps thereafter.

    ~(16 + 36 * (my int $ri = $r < .45098e0 ?? my int $rc = $r >= .1875e0
                                            !! my int $rf = floor(6.375e0 * $r - .875e0))
         +  6 * (my int $gi = $g < .45098e0 ?? my int $gc = $g >= .1875e0
                                            !! my int $gf = floor(6.375e0 * $g - .875e0))
         +      (my int $bi = $b < .45098e0 ?? my int $bc = $b >= .1875e0
                                            !! my int $bf = floor(6.375e0 * $b - .875e0)))
}


#| Convert an rgb triplet (each in the 0..1 range) into a single luminance value
multi rgb-luma(Real:D $r, Real:D $g, Real:D $b) is export {
    # 1/4, 11/16, 1/16 RGB luma coefficients (chosen to be between coefficients
    # used by HDTV and HDR standards and also exact with binary arithmetic)
      .2500e0 * (my num $rn = $r.Num)
    + .6875e0 * (my num $rg = $g.Num)
    + .0625e0 * (my num $rb = $b.Num)
}


#| Convert an rgb triplet (each in the 0..1 range) into a single luminance value
multi rgb-luma(num $r, num $g, num $b) is export {
    # 1/4, 11/16, 1/16 RGB luma coefficients (chosen to be between coefficients
    # used by HDTV and HDR standards and also exact with binary arithmetic)
      .2500e0 * $r
    + .6875e0 * $g
    + .0625e0 * $b
}


#| Convert a grayscale value (in the 0..1 range) to a valid cell color
multi gray-color(Real:D $gray) is export {
    # Use the hi-res gray ramp plus true black and white (from the color cube).

    # Note: Due to an off-by-one error in the original xterm ramp mapping, the
    #       gray ramp is *NOT* centered between the black and white ends; here
    #       we choose 1/64 and 61/64 as the crossover points and map the 15/16
    #       between them to the grey ramp.  For more info see:
    #
    # https://github.com/ThomasDickey/xterm-snapshots/blob/master/256colres.pl

    (my num $gn = $gray.Num) <  .015625e0 ??  '16' !!
                         $gn >= .953125e0 ?? '231' !!
                        ~(232 + my int $g = floor(25.6e0 * ($gn - .015625e0)))
}


#| Convert a grayscale value (in the 0..1 range) to a valid cell color
multi gray-color(num $gray) is export {
    # Use the hi-res gray ramp plus true black and white (from the color cube).

    # Note: Due to an off-by-one error in the original xterm ramp mapping, the
    #       gray ramp is *NOT* centered between the black and white ends; here
    #       we choose 1/64 and 61/64 as the crossover points and map the 15/16
    #       between them to the grey ramp.  For more info see:
    #
    # https://github.com/ThomasDickey/xterm-snapshots/blob/master/256colres.pl

    $gray <  .015625e0 ??  '16' !!
    $gray >= .953125e0 ?? '231' !!
                       ~(232 + my int $g = floor(25.6e0 * ($gray - .015625e0)))
}


#| Convert an rgb triplet (each in the 0..1 range) to a grayscale cell color
multi gray-color(Real:D $r, Real:D $g, Real:D $b) is export {
    gray-color(rgb-luma($r, $g, $b))
}


#| Convert an rgb triplet (each in the 0..1 range) to a grayscale cell color
multi gray-color(num $r, num $g, num $b) is export {
    gray-color(rgb-luma($r, $g, $b))
}


#| Merge color strings together and simplify result, with later settings
#| overriding earlier ones.  Note that simplification is incomplete for
#| performance reasons.
multi color-merge(@colors) is export {
    # Split into individual SGR descriptors
    my @split = @colors.join(' ').words.reverse;

    # If there are any resets, only keep the last reset and the remaining
    # descriptors after it
    my $reset = @split.first('reset', :k);
    @split.splice($reset + 1) if $reset.defined;

    # Avoid further work for trivial cases; otherwise, actually calc overrides
    @split <= 1 ?? @split[0] // ''
                !! do {
        # Separate background from others
        my $background = @split.first(*.starts-with('on_'));
        my @others     = @split.grep(!*.starts-with('on_')).unique.reverse;
        @others.push($background) if $background;

        # Final color info!
        @others.join(' ')
    }
}


#| Merge color strings together and simplify result, with later settings
#| overriding earlier ones.  Note that simplification is incomplete for
#| performance reasons.
multi color-merge(*@colors) is export {
    color-merge(@colors)
}
