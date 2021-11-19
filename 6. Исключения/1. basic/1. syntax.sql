/**
  EXCEPTION
 */



declare

    e_my_exception exception;

begin

    null; --code

exception

    when no_data_found then --название системной ошибки

        null; --code
        --если вы в функции не забывайте делать здесь return;

    when e_my_exception then --название вашей ошибки

        null; --code
    /**
      - блоков when может быть сколько угодно
      - внутри when может быть опять begin exception end
     */

end;
/
