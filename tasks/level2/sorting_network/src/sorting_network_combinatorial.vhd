library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sorting_network_pkg.all;

architecture arch_combinatorial of sorting_network is
    subtype stage_t is word_array_t(0 to 9);
    type stages_t is array (0 to 7) of stage_t;
    signal stages : stages_t := (others => (others => (others => '0')));
begin

    process (all)
        procedure swap(signal src : stage_t; signal dst : out stage_t;
                idx0, idx1 : integer) is
        begin
            if unsigned(src(idx0)) <= unsigned(src(idx1)) then
                dst(idx0) <= src(idx0);
                dst(idx1) <= src(idx1);
            else
                dst(idx0) <= src(idx1);
                dst(idx1) <= src(idx0);
            end if;
        end procedure;

        procedure fill_stage_0 is
        begin
            stages(0) <= unsorted_data;
            swap(unsorted_data, stages(0), 0, 8);
            swap(unsorted_data, stages(0), 0, 8);
            swap(unsorted_data, stages(0), 1, 9);
            swap(unsorted_data, stages(0), 2, 7);
            swap(unsorted_data, stages(0), 3, 5);
            swap(unsorted_data, stages(0), 4, 6);
        end procedure;

        procedure fill_stage_1 is
        begin
            stages(1) <= stages(0);
            swap(stages(0), stages(1), 0, 2);
            swap(stages(0), stages(1), 1, 4);
            swap(stages(0), stages(1), 5, 8);
            swap(stages(0), stages(1), 7, 9);
        end procedure;

        procedure fill_stage_2 is
        begin
            stages(2) <= stages(1);
            swap(stages(1), stages(2), 0, 3);
            swap(stages(1), stages(2), 2, 4);
            swap(stages(1), stages(2), 5, 7);
            swap(stages(1), stages(2), 6, 9);
        end procedure;

        procedure fill_stage_3 is
        begin
            stages(3) <= stages(2);
            swap(stages(2), stages(3), 0, 1);
            swap(stages(2), stages(3), 3, 6);
            swap(stages(2), stages(3), 8, 9);
        end procedure;

        procedure fill_stage_4 is
        begin
            stages(4) <= stages(3);
            swap(stages(3), stages(4), 1, 5);
            swap(stages(3), stages(4), 2, 3);
            swap(stages(3), stages(4), 4, 8);
            swap(stages(3), stages(4), 6, 7);
        end procedure;

        procedure fill_stage_5 is
        begin
            stages(5) <= stages(4);
            swap(stages(4), stages(5), 1, 2);
            swap(stages(4), stages(5), 3, 5);
            swap(stages(4), stages(5), 4, 6);
            swap(stages(4), stages(5), 7, 8);
        end procedure;

        procedure fill_stage_6 is
        begin
            stages(6) <= stages(5);
            swap(stages(5), stages(6), 2, 3);
            swap(stages(5), stages(6), 4, 5);
            swap(stages(5), stages(6), 6, 7);
        end procedure;

        procedure fill_stage_7 is
        begin
            stages(7) <= stages(6);
            swap(stages(6), stages(7), 3, 4);
            swap(stages(6), stages(7), 5, 6);
        end procedure;
    begin
        if res_n = '0' then
            stages <= (others => (others => (others => '0')));
            unsorted_ready <= '0';
            sorted_valid <= '0';
        else
            fill_stage_0;
            fill_stage_1;
            fill_stage_2;
            fill_stage_3;
            fill_stage_4;
            fill_stage_5;
            fill_stage_6;
            fill_stage_7;
            unsorted_ready <= '1';
            sorted_valid <= '1';
        end if;
    end process;

    -- sorted_data <= stages(7);
    sorted_data <= unsorted_data;
end architecture;
