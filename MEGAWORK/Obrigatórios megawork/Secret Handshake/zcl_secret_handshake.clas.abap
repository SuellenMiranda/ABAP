CLASS zcl_secret_handshake DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS get_commands
      IMPORTING code            TYPE i
      RETURNING VALUE(commands) TYPE string_table.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_secret_handshake IMPLEMENTATION.

  METHOD get_commands.
    DATA: actions           TYPE string_table, " Lista de ações
          reversed_actions  TYPE string_table, " Lista de ações revertidas
          binary_code        TYPE string,       " Código binário
          temp_code          TYPE i,            " Código temporário para conversão
          remainder          TYPE i,            " Resto da divisão para binário
          reverse_flag       TYPE abap_bool.    " Flag para reversão

    " Inicializar ações e binário
    CLEAR: actions, reversed_actions, binary_code.
    temp_code = code.

    " Converter número para binário (5 bits)
    DO 5 TIMES.
      remainder = temp_code MOD 2.
      binary_code = |{ remainder }{ binary_code }|.
      temp_code = temp_code DIV 2.
    ENDDO.

    " Determinar ações com base no binário
    IF binary_code+4(1) = '1'. APPEND 'wink' TO actions. ENDIF.
    IF binary_code+3(1) = '1'. APPEND 'double blink' TO actions. ENDIF.
    IF binary_code+2(1) = '1'. APPEND 'close your eyes' TO actions. ENDIF.
    IF binary_code+1(1) = '1'. APPEND 'jump' TO actions. ENDIF.

    " Verificar se a ordem precisa ser revertida
    IF binary_code+0(1) = '1'.
      LOOP AT actions INTO DATA(action).
        INSERT action INTO reversed_actions INDEX 1.
      ENDLOOP.
      commands = reversed_actions.
    ELSE.
      commands = actions.
    ENDIF.

  ENDMETHOD.

ENDCLASS.