library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ScoreMatrixTb is
    generic (
        g_BITS : POSITIVE := 32;
        g_LENGTH : POSITIVE := 100
    );
end ScoreMatrixTb;

architecture Blastn of ScoreMatrixTb is

    component ScoreMatrix is
        generic (
            g_MAXSTEP : POSITIVE := 10;
            g_MATSIZE : POSITIVE := 10; -- square matrix size
            g_BITS : POSITIVE := 32;    -- result size in bits (ie. 32-bit integer result)
            g_LENGTH : POSITIVE := 100  -- length of the query and subject in letters
        );
        port (
            --tmp : out INTEGER;
            clk         : in  STD_LOGIC;    -- board clock
            rst         : in  STD_LOGIC;    -- reset the score counter
            done        : out STD_LOGIC;
            rx_done     : in  STD_LOGIC;
            tx_done     : in  STD_LOGIC;
            
            -- Smith-Waterman match, mismatch, and gap scores
            i_match     : in  SIGNED(1 downto 0);
            i_mismatch  : in  SIGNED(1 downto 0);
            i_gap       : in  SIGNED(1 downto 0);
            
            i_length    : in  UNSIGNED(g_BITS - 1 downto 0);                -- length of the query or the subject
            i_query     : in  STD_LOGIC_VECTOR(g_LENGTH * 3 - 1 downto 0);  -- the query, groups of 3 adjacent bits per character
            i_subject   : in  STD_LOGIC_VECTOR(g_LENGTH * 2 - 1 downto 0);  -- the subject, groups of 2 adjacent bits per character
            o_score     : out UNSIGNED(g_BITS - 1 downto 0)                 -- Smith-Waterman max score
        );
    end component;

    constant jump : time := 10 ns;

    signal clk, rst, done, rx_done, tx_done : STD_LOGIC;
    signal match, mismatch, gap : SIGNED(1 downto 0);

    signal length : UNSIGNED(g_BITS - 1 downto 0);
    signal query : STD_LOGIC_VECTOR(g_LENGTH * 3 - 1 downto 0);
    signal subject : STD_LOGIC_VECTOR(g_LENGTH * 2 - 1 downto 0);
    signal score : UNSIGNED(g_BITS - 1 downto 0);
    
    --signal state : INTEGER;

begin

    CLK_GEN: process
    begin
        clk <= '1';
        wait for jump / 2;
        clk <= '0';
        wait for jump / 2;
    end process;

    UUT: ScoreMatrix
        generic map (
            g_MAXSTEP => 10,
            g_MATSIZE => 20,
            g_BITS    => g_BITS,
            g_LENGTH  => g_LENGTH
        )
        port map (
            --tmp => state,
            clk        => clk,
            rst        => rst,
            done       => done,
            rx_done    => rx_done,
            tx_done    => tx_done,
            i_match    => match,
            i_mismatch => mismatch,
            i_gap      => gap,
            i_length   => length,
            i_query    => query,
            i_subject  => subject,
            o_score    => score
        );
    
    TESTBENCH: process
    begin

        match    <= "10";
        mismatch <= "11";
        gap      <= "11";
        rx_done  <= '0';
        tx_done  <= '0';

        length  <= x"0000000B";
        query(32 downto 0)   <= "011011011011011011011011011011011";
        subject(21 downto 0) <= "1111111111111111111111";
        query(g_LENGTH * 3 - 1 downto 11)   <= (others => '0');
        subject(g_LENGTH * 2 - 1 downto 11) <= (others => '0');

        -- start process
        wait for jump;
        rst <= '1';
        wait for jump;
        rst <= '0';
        wait for jump;

        -- simulate rx receiving
        wait for jump*5;

        -- begin scoring
        rx_done <= '1';
        wait for jump;
        rx_done <= '0';
        wait for jump;

        -- wait for scoring process
        while done = '0' loop
            wait for jump;
        end loop;

        -- simulate tx sending
        tx_done <= '1';
        wait for jump;
        tx_done <= '0';
        wait for jump;

        wait for jump*50;



        -- second simulation

        match    <= "10";
        mismatch <= "11";
        gap      <= "11";
        rx_done  <= '0';
        tx_done  <= '0';

        length  <= x"0000000F";
        query(47 downto 0)   <= "011011011011011011011011011011011011011011011011";
        subject(31 downto 0) <= "11111111111111111111111111111111";
        query(g_LENGTH * 3 - 1 downto 11)   <= (others => '0');
        subject(g_LENGTH * 2 - 1 downto 11) <= (others => '0');

        -- start process
        wait for jump;
        rst <= '1';
        wait for jump;
        rst <= '0';
        wait for jump;

        -- simulate rx receiving
        wait for jump*5;

        -- begin scoring
        rx_done <= '1';
        wait for jump;
        rx_done <= '0';
        wait for jump;

        -- wait for scoring process
        while done = '0' loop
            wait for jump;
        end loop;

        -- simulate tx sending
        tx_done <= '1';
        wait for jump;
        tx_done <= '0';
        wait for jump;

        wait for jump*50;

         -- third simulation

         match    <= "10";
         mismatch <= "11";
         gap      <= "11";
         rx_done  <= '0';
         tx_done  <= '0';
 
         length  <= x"0000000F";
         query(47 downto 0)   <= "011011011011011011011011011011011011011011011011";
         subject(31 downto 0) <= "00000000000000000000000000000000";
         query(g_LENGTH * 3 - 1 downto 11)   <= (others => '0');
         subject(g_LENGTH * 2 - 1 downto 11) <= (others => '0');
 
         -- start process
         wait for jump;
         rst <= '1';
         wait for jump;
         rst <= '0';
         wait for jump;
 
         -- simulate rx receiving
         wait for jump*5;
 
         -- begin scoring
         rx_done <= '1';
         wait for jump;
         rx_done <= '0';
         wait for jump;
 
         -- wait for scoring process
         while done = '0' loop
             wait for jump;
         end loop;
 
         -- simulate tx sending
         tx_done <= '1';
         wait for jump;
         tx_done <= '0';
         wait for jump;

        -- finish
        wait;

    end process;

end Blastn;