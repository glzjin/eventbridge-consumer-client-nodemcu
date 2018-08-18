uart.setup(1, 9600, 8, uart.PARITY_NONE, uart.STOPBITS_1, 0)

function rf_button1_learn()
    uart.write(1, 0xaa, 0x01, 0xff)
end

function rf_button1_press()
    uart.write(1, 0xbb, 0x01, 0xff)
end

function rf_button2_learn()
    uart.write(1, 0xaa, 0x02, 0xff)
end

function rf_button2_press()
    uart.write(1, 0xbb, 0x02, 0xff)
end

function rf_button3_learn()
    uart.write(1, 0xaa, 0x03, 0xff)
end

function rf_button3_press()
    uart.write(1, 0xbb, 0x03, 0xff)
end

function rf_button4_learn()
    uart.write(1, 0xaa, 0x03, 0xff)
end

function rf_button4_press()
    uart.write(1, 0xbb, 0x03, 0xff)
end

function rf_event_reg(event_table, index)
    event_table[index + 1] = rf_button1_press
    event_table[index + 2] = rf_button2_press
    event_table[index + 3] = rf_button3_press
    event_table[index + 4] = rf_button4_press
    event_table[index + 5] = rf_button1_learn
    event_table[index + 6] = rf_button2_learn
    event_table[index + 7] = rf_button3_learn
    event_table[index + 8] = rf_button4_learn
end