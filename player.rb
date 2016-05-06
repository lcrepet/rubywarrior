class Player
    def initialize
        @health = 20
        @wall = false
    end
  def play_turn(warrior)
      puts warrior.feel
    if !@wall && warrior.feel.wall?
        warrior.pivot!
        @wall = true
    else
        if !@wall && is_there_enemy?(warrior.look(:backward))
            warrior.shoot! :backward
        elsif !@wall && is_there_captive?(warrior.look(:backward))
            if warrior.feel(:backward).captive?
                warrior.rescue!:backward
            else
                warrior.walk! :backward
            end
        else
            if warrior.feel.captive?
                warrior.rescue!
            elsif !warrior.feel.empty?
                 warrior.attack!
            else
                look = warrior.look
                if !look[1].empty? && !look[1].captive? && !look[1].wall?
                    warrior.shoot!
                elsif !look[2].empty? && !look[2].captive? && !look[1].captive? && !look[2].wall?
                    warrior.shoot!
                 else
                    if @health<= warrior.health && warrior.health < 20
                        warrior.rest!
                    elsif @health > warrior.health && warrior.health < 14
                        warrior.walk! :backward
                    else
                        warrior.walk!
                    end
                end
            end
        end
    end
    @health = warrior.health
  end

  def is_completely_empty? look
    look.each{|x| return false if !x.empty?}
    true
  end

  def is_there_enemy? look
    look.each do |x|
        return false if x.captive?
        return true if !x.empty? && !x.wall?
    end
    false
  end

  def is_there_captive? look
    look.each{|x| return true if x.captive?}
    false
  end
end
