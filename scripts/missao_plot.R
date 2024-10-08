Sys.setlocale("LC_CTYPE", "en_US.UTF-8")

#########
# GEOBR #
#########

library(ggplot2)
library(sf)
library(dplyr)

states <- sf::st_read("data/BR.shp")
colnames(states)[2] <- "abbrev_state"
colnames(states)[5] <- "name_region"

#######
# TSE #
#######

tse <- read.table("data/tse.tsv", header = T)
colnames(tse)[1] = "abbrev_state"
tse$VV <- as.numeric(gsub("[.]", "", tse$VV))
tse$EV <- as.numeric(gsub("[.]", "", tse$EV))
tse <- tse %>% mutate(VV05 = VV * 0.005, EV01 = EV * 0.001)

##############
# APOIAMENTO #
##############

df <- read.csv("data/mbl.csv", header = T)
colnames(df) <- c("abbrev_state", "votos", "DATE")
df <- df %>% filter(as.Date(DATE) == max(as.Date(DATE)))


#############
# JOIN DATA #
#############

states_join = list(df, tse, states)
states_join <- left_join(states, df, by = "abbrev_state")
states_join <- left_join(states_join, tse, by = "abbrev_state")

tab <- states_join %>% as.data.frame() %>% select(name_region, abbrev_state, votos, EV01) %>%
  mutate(EV01 = round(EV01, 0)) %>%
  rbind(., list("Total","Total", sum(.$votos), round(sum(states_join$VV05),0)))

###########
# FIGURES #
###########

leg_size = 10

fig1 <- ggplot() +
  geom_sf(data=states_join, aes(fill=votos / EV * 1e+03), color= "#272727", size=.15) +
  scale_fill_gradient2(na.value="white", low="#272727", mid = "grey", high="#FCBD27", midpoint = 1) +
  labs(subtitle="           Apoiamentos por estado (A) / Apoiamentos mínimos (AM)",
       size=leg_size, fill = "A/AM") +
  theme_void()

fig2 <- ggplot() +
  geom_sf(data=states_join, aes(fill=log10(votos + 1)), color= "#272727", size=.15) +
  scale_fill_gradient2(mid="#272727", high="#FCBD27") +
  labs(subtitle="           Apoiamentos por estado", size=leg_size, fill = "Apoiamentos\n(log10)") +
  theme_void()

fig3 <- ggplot() +
  geom_sf(data=states_join, aes(fill= ifelse(votos > EV01, "Sim", "Não")), color= "#272727", size=.15) +
  scale_fill_manual(values = c("#272727", "#FCBD27")) +
  labs(subtitle = "           Estados aptos a ter diretório", size=8, fill = "Aptos") +
  theme_void()

msg <- paste0("** Última atualização dos dados: ", as.Date(df[1,3]))

fig4 <- tab %>% filter(abbrev_state != "Total") %>%
  mutate(perc = ifelse(round(votos /EV01 * 100, 1) >= 100, 100, round(votos /EV01 * 100, 1))) %>%
  mutate(label = paste0(perc, "%")) %>%
  ggplot(aes(x = reorder(paste0("(",votos,") ",abbrev_state), votos/ EV01), y = perc, fill = ifelse(perc >= 100, "Sim", "Não"))) +
  scale_y_continuous(expand = expansion(mult = c(0, .1)), breaks = c(0, 25, 50, 75, 100)) +
  geom_col() + scale_fill_manual(values = c("#272727", "#FCBD27")) +
  theme_classic() + coord_flip(ylim = c(0, 110)) +
  labs(fill = "Aptos", x = "(Apoiamentos totais) Sigla do estado",
  y = "Porcentagem (apoiamentos para meta)", title = "Apoiamentos mínimos por estado (%)",
  caption = paste0("* Porcentagem máxima da figura <= 100%\n", msg)) +
  geom_text(aes(label= ifelse(votos >= EV01, label, paste0(label, " (",EV01-votos,")"))),position = position_dodge2(0.9), hjust = -0.2, fontface=2, cex=2.5, show.legend = F) +
  theme(title = element_text(size = 8),axis.title = element_text(size = 10),
        legend.position = "inside", legend.position.inside = c(.85, .5),
        plot.caption.position = "plot", plot.caption = element_text(hjust = 0.5))

my_palette <- colorRampPalette(c("#272727", "grey", "#FCBD27"))

fig5 <- tab %>% filter(abbrev_state != "Total") %>% mutate(prop = round(votos/sum(votos)*100,1)) %>%
  filter(prop != 0) %>%
  arrange(desc(abbrev_state)) %>%
  mutate(lab.ypos = cumsum(prop) - 0.5*prop) %>%
  mutate(label = paste0(abbrev_state,"\n",prop, "%")) %>%
  ggplot(aes(x = "", y = prop, fill = abbrev_state)) +
  geom_bar(width = 1, stat = "identity", color = "white") +
  scale_fill_manual(values = my_palette(11)) +
  coord_polar("y", start = 0) +
  ggrepel::geom_label_repel (aes(y = lab.ypos, segment.size = 0,
                            label = label),
                            color = "white", nudge_x = 0.7) +
  theme_void() + labs(title = "   Participação por estado no total") +
  theme(legend.position="none")

png(filename = paste0("fig/mbl_",Sys.Date(),".png"), res = 250, width = 4000, height = 2000)
cowplot::plot_grid(cowplot::plot_grid(fig2, fig3, fig1, fig5, ncol = 2, scale = c(1,1,1,0.85)), fig4, rel_widths = c(1,0.3))
dev.off()
