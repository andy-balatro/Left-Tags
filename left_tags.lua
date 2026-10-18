-- Stacks skip tags up the left margin instead of the right one, so something can sit in the
-- bottom-right corner (e.g. a chat panel) without covering them.

-- Lovely appends this to the game's main.lua, so the block keeps these locals out of the
-- game's and other mods' way.
do
  -- Small enough to fit between the window's edge and the HUD at 16:9.
  local TAG_SIZE = 0.6
  -- Game:start_run puts the HUD's left edge this far into the left margin.
  local HUD_LEFT = -0.7

  -- A tag UIBox is 0.05 of padding around its sprite.
  local TAG_WIDTH = TAG_SIZE + 0.1

  -- The game's add_tag, except that the first tag is anchored in the left margin and tags are
  -- smaller. Moving a tag after it's created doesn't work: with a Strong bond the drawn box only
  -- follows offset changes while its anchor moves, and the room stands still.
  function add_tag(_tag)
    G.HUD_tags = G.HUD_tags or {}
    local tag_sprite_ui, tag_sprite = _tag:generate_UI(TAG_SIZE)
    -- Its tooltip opens to the right, see Node:hover below.
    tag_sprite.config.left_tags_hud_tag = true
    local previous = G.HUD_tags[#G.HUD_tags]
    G.HUD_tags[#G.HUD_tags + 1] = UIBox({
      definition = { n = G.UIT.ROOT, config = { align = "cm", padding = 0.05, colour = G.C.CLEAR }, nodes = {
        tag_sprite_ui,
      } },
      config = previous and { align = "tm", offset = { x = 0, y = 0 }, major = previous } or {
        align = "bli",
        offset = { x = HUD_LEFT - 0.05 - TAG_WIDTH, y = 0 },
        major = G.ROOM_ATTACH,
      },
    })
    discover_card(G.P_TAGS[_tag.key])

    for i = 1, #G.GAME.tags do
      G.GAME.tags[i]:apply_to_run({ type = "tag_add", tag = _tag })
    end

    G.GAME.tags[#G.GAME.tags + 1] = _tag
    _tag.HUD_tag = G.HUD_tags[#G.HUD_tags]
  end

  -- The game opens a tag's tooltip to its left, which is off screen now. Its hover handler sets
  -- where the tooltip goes right before calling Node.hover, which creates it.
  local node_hover_ref = Node.hover
  function Node:hover(...)
    if self.config and self.config.left_tags_hud_tag and self.config.h_popup_config then
      self.config.h_popup_config.align = "cr"
      self.config.h_popup_config.offset = { x = 0.1, y = 0 }
    end
    return node_hover_ref(self, ...)
  end

  -- Using up the first tag re-anchors the next one to the right margin. The game moves it with a
  -- Weak bond, so re-anchoring it slides it down the left margin instead.
  local remove_ref = Tag.remove
  function Tag:remove(...)
    local result = remove_ref(self, ...)
    local first = G.HUD_tags and G.HUD_tags[1]
    if first then
      first:set_alignment({
        major = G.ROOM_ATTACH,
        type = "bli",
        offset = { x = HUD_LEFT - 0.05 - TAG_WIDTH, y = 0 },
        bond = "Weak",
      })
    end
    return result
  end
end
