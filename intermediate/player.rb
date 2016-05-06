class Player
    DIRECTIONS = [:forward, :backward, :left, :right]
    MAX_HEALTH = 20

    def initialize
        @health = MAX_HEALTH
        @new_environment = true
        @enemies = Array.new
        @captives = Array.new
        @nothing = Array.new
    end

    def initialize_environment
        DIRECTIONS.each{|d|
            @environment[d] = ""
        }
    end

    def play_turn(warrior)
        scan_environment(warrior) if @new_environment
        nbe = not_bound_enemies warrior
        puts @enemies.count
        if @enemies.count > 0
            case @enemies.count
            when 1
                warrior.attack!(@enemies.first)
                if(warrior.feel(@enemies.first).empty?)
                   @nothing << @enemies.shift
                end
            when 2
                dir = where_is_enemy? warrior
                if dir
                    warrior.attack!(dir)
                    if(warrior.feel(dir).empty?)
                        @nothing << @enemies.delete(dir)
                        puts " Il est mort ! " + @enemies.count
                    end
                end
            when 3
                if @nothing.count > 0
                    if warrior.health < 14
                        warrior.walk! @nothing.first
                        @new_environment = true
                    elsif nbe == 1
                        dir = where_is_enemy? warrior
                        warrior.attack! dir
                        if warrior.feel(dir).empty?
                            @nothing << @enemies.delete(dir)
                        end
                    else
                        warrior.bind! @enemies[nbe-1]
                    end
                else
                    dir = @captives.shift
                    warrior.rescue! dir
                    @nothing << dir
                end
            else
                puts @enemies.count
                puts "Je suis coincé !"
            end
        elsif @captives.count > 0
            dir = @captives.shift
            warrior.rescue! dir
            @nothing << dir
        elsif warrior.health < MAX_HEALTH
            warrior.rest!
        else
            puts "Je dois marcher !"
            warrior.walk!(warrior.direction_of_stairs)
            @new_environment = true
        end
    end

    def scan_environment warrior
        @captives.clear
        @enemies.clear
        @nothing.clear
        @binded_enemies = 0
        DIRECTIONS.each{|d|
            space = warrior.feel(d)
            if space.captive?
                @captives << d
            elsif space.empty?
                @nothing << d
            elsif !space.wall?
                @enemies << d
            end
        }
        @new_environment = false
    end

    def not_bound_enemies warrior
        result = 0
        @enemies.each{|e|
            result += 1 unless warrior.feel.captive?
        }
        return result
    end

    def where_is_enemy? warrior
        DIRECTIONS.each{|d|
            space = warrior.feel(d)
            return d if (!space.empty? and is_that_thing_enemy? space)
        }
        nil
    end

    def is_that_thing_enemy? thing
        return true unless (thing.captive? or thing.wall?)
        false
    end
end
