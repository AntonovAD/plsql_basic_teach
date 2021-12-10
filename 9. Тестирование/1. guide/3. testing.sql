/**
  TESTING

  DataGrip имеет встроенную поддержку TOOL_UT3
 */



begin
    --запустит тесты во всей БД
    --TOOL_UT3.UT.RUN();

    --запустит тесты во всей схеме
    --TOOL_UT3.UT.RUN('ANTONOV');

    --запустит конкретный набор тестов
    TOOL_UT3.UT.RUN('ANTONOV.TEST_PKG_PATIENT');
end;
/
