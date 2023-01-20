-- Add these GUIDs to Global with the same name
-- i.e DISORDER_DECK_GUID = "123ABC"
DISORDER_DECK_GUID = Global.getVar('DISORDER_DECK_GUID') -- face up disorders
MAIN_DECK_GUID     = Global.getVar('MAIN_DECK_GUID')     -- face down deck

-- deal 4 unique disorder to a player
function deal_disorders(deck, x, color)

    -- array to prevent disorder duplication
    local psyche = {}

    -- deal disorders
    i = 0
    while (i < 4) do
::try_again::
        -- postion cards in front of player colors
        -- disorders are already face up so do not flip
        local card = deck.dealToColorWithOffset({x  + (i * 3), 0, 5}, false, color)        
        local name = card.getName()

        -- check that card does not already exist in psyche
        for j = 1, 4 do            
            -- early out when psyche is not full
            if psyche[j] == nil then
                break 
            end

            -- found a duplicate disorder, return it and try again
            if psyche[j] == name then
                deck.putObject(card)
                goto try_again -- jump back to top of loop
            end
        end

        -- disorder is unique at this point, track it
        psyche[i] = name

        i = i + 1
    end
end

-- deals disorders and starting hand for 4 players
function set_up_game()
    
    -- get the disorder deck object
    local disorders = getObjectFromGUID(DISORDER_DECK_GUID)
    disorders.randomize()

    -- deal disorders for 4 players 
    deal_disorders(disorders,   -7, "White")
    deal_disorders(disorders, -2.1, "Red")
    deal_disorders(disorders,   -7, "Green")
    deal_disorders(disorders, -2.1, "Blue")

    -- add remaining disorders to deck and shuffle
    local deck = getObjectFromGUID(MAIN_DECK_GUID)
    disorders.flip()
    deck.putObject(disorders)
    deck.randomize()

    -- deal 4 cards to each player
    deck.deal(4)

    -- remove button
    destroyObject(self)
end