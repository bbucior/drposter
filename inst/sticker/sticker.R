# Use the [hexSticker package](https://github.com/GuangchuangYu/hexSticker) to generate a package logo
# Graduation cap from CC0 openclipart: https://openclipart.org/detail/244447/minimliast-graduation-hat
# This code very closely derived from the MIT License package bcbioSmallRna:
# https://github.com/lpantano/bcbioSmallRna/blob/master/inst/sticker/sticker.R

hexSticker::sticker("inst/sticker/graduation_hat.svg",
                    #url = "https://github.com/bbucior/drposter",
                    u_size = 5,
                    package = "drposter",
                    s_x = 1.0,
                    s_y = 0.8,
                    s_width = 0.5,
                    s_heigh = 0.5,
                    p_x = 1,
                    p_y = 1.4,
                    h_color = "#00579E",
                    h_size = 1,
                    h_fill = "white",
                    p_color = "#00579E",
                    p_size = 24,  # formerly 17
                    filename="inst/sticker/drposter.png")
