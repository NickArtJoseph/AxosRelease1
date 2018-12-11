/**
 * @description Unit tests for TriggerHandler
 * @author <p>Copyright (c) 2013 Kevin M. O'Hara</p> 
 * 
 * <p>Code repository:  https://github.com/kevinohara80/sfdc-trigger-framework/</p>
 * 
 * <p>LICENSE:</br></p>
 * <p>Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom
 * the Software is furnished to do so, subject to the following
 * conditions:</p>
 *
 * <p>The above copyright notice and this permission notice shall
 * be included in all copies or substantial portions of the
 * Software.</p>
 *
 * <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY
 * KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS
 * OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.</p>
 */
@isTest
private class TriggerHandler_Test {

  /** Context error message */
  private static final String TRIGGER_CONTEXT_ERROR = 'Trigger handler called outside of Trigger execution';

  /** Name of last method called */
  private static String lastMethodCalled;

  /** Trigger handler */
  private static TriggerHandler_Test.TestHandler handler;

  /** static initialization */
  static {
    handler = new TriggerHandler_Test.TestHandler();
    // override its internal trigger detection
    handler.isTriggerExecuting = true;
  }

  /* unit tests */

  /** Context test */
  @isTest
  static void testBeforeInsert() {
    beforeInsertMode();
    handler.run();
    System.assertEquals('beforeInsert', lastMethodCalled, 'last method should be beforeInsert');
  }

  /** Context test */
  @isTest
  static void testBeforeUpdate() {
    beforeUpdateMode();
    handler.run();
    System.assertEquals('beforeUpdate', lastMethodCalled, 'last method should be beforeUpdate');
  }

  /** Context test */
  @isTest
  static void testBeforeDelete() {
    beforeDeleteMode();
    handler.run();
    System.assertEquals('beforeDelete', lastMethodCalled, 'last method should be beforeDelete');
  }

  /** Context test */
  @isTest
  static void testAfterInsert() {
    afterInsertMode();
    handler.run();
    System.assertEquals('afterInsert', lastMethodCalled, 'last method should be afterInsert');
  }

  /** Context test */
  @isTest
  static void testAfterUpdate() {
    afterUpdateMode();
    handler.run();
    System.assertEquals('afterUpdate', lastMethodCalled, 'last method should be afterUpdate');
  }

  /** Context test */
  @isTest
  static void testAfterDelete() {
    afterDeleteMode();
    handler.run();
    System.assertEquals('afterDelete', lastMethodCalled, 'last method should be afterDelete');
  }

  /** Context test */
  @isTest
  static void testAfterUndelete() {
    afterUndeleteMode();
    handler.run();
    System.assertEquals('afterUndelete', lastMethodCalled, 'last method should be afterUndelete');
  }

  /** Context test */
  @isTest 
  static void testNonTriggerContext() {
    try{
      handler.run();
      System.assert(false, 'the handler ran but should have thrown');
    } catch(TriggerHandler.TriggerHandlerException te) {
      System.assertEquals(TRIGGER_CONTEXT_ERROR, te.getMessage(), 'the exception message should match');
    } catch(Exception e) {
      System.assert(false, 'the exception thrown was not expected: ' + e.getTypeName() + ': ' + e.getMessage());
    }
  }

  /** Bypass API Test */
  @isTest
  static void testBypassAPI() {
    afterUpdateMode();

    // test a bypass and run handler
    TriggerHandler.bypass('TestHandler');
    handler.run();
    System.assertEquals(null, lastMethodCalled, 'last method should be null when bypassed');
    System.assertEquals(true, TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
    resetTest();

    // clear that bypass and run handler
    TriggerHandler.clearBypass('TestHandler');
    handler.run();
    System.assertEquals('afterUpdate', lastMethodCalled, 'last method called should be afterUpdate');
    System.assertEquals(false, TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
    resetTest();

    // test a re-bypass and run handler
    TriggerHandler.bypass('TestHandler');
    handler.run();
    System.assertEquals(null, lastMethodCalled, 'last method should be null when bypassed');
    System.assertEquals(true, TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
    resetTest();

    // clear all bypasses and run handler
    TriggerHandler.clearAllBypasses();
    handler.run();
    System.assertEquals('afterUpdate', lastMethodCalled, 'last method called should be afterUpdate');
    System.assertEquals(false, TriggerHandler.isBypassed('TestHandler'), 'test handler should be bypassed');
    resetTest();
  }

  /** Test maximum loops */
  @isTest
  static void testLoopCount() {
    beforeInsertMode();
    
    // set the max loops to 2
    handler.setMaxLoopCount(2);

    // run the handler twice
    handler.run();
    handler.run();

    // clear the tests
    resetTest();

    try {
      // try running it. This should exceed the limit.
      handler.run();
      System.assert(false, 'the handler should throw on the 3rd run when maxloopcount is 3');
    } catch(TriggerHandler.TriggerHandlerException te) {
      // we're expecting to get here
      System.assertEquals(null, lastMethodCalled, 'last method should be null');
    } catch(Exception e) {  
      System.assert(false, 'the exception thrown was not expected: ' + e.getTypeName() + ': ' + e.getMessage());
    }

    // clear the tests
    resetTest();

    // now clear the loop count
    handler.clearMaxLoopCount();

    try {
      // re-run the handler. We shouldn't throw now.
      handler.run();
      System.assertEquals('beforeInsert', lastMethodCalled, 'last method should be beforeInsert');
    } catch(TriggerHandler.TriggerHandlerException te) {
      System.assert(false, 'running the handler after clearing the loop count should not throw');
    } catch(Exception e) {  
      System.assert(false, 'the exception thrown was not expected: ' + e.getTypeName() + ': ' + e.getMessage());
    }
  }

  /** Test loop count */
  @isTest
  static void testLoopCountClass() {
    TriggerHandler.LoopCount lc = new TriggerHandler.LoopCount();
    System.assertEquals(5, lc.getMax(), 'max should be five on init');
    System.assertEquals(0, lc.getCount(), 'count should be zero on init');

    lc.increment();
    System.assertEquals(1, lc.getCount(), 'count should be 1');
    System.assertEquals(false, lc.exceeded(), 'should not be exceeded with count of 1');

    lc.increment();
    lc.increment();
    lc.increment();
    lc.increment();
    System.assertEquals(5, lc.getCount(), 'count should be 5');
    System.assertEquals(false, lc.exceeded(), 'should not be exceeded with count of 5');

    lc.increment();
    System.assertEquals(6, lc.getCount(), 'count should be 6');
    System.assertEquals(true, lc.exceeded(), 'should not be exceeded with count of 6');
  }

  /** Test get handler name */
  @isTest 
  static void testGetHandlerName() {
    System.assertEquals('TestHandler', handler.getHandlerName(), 'handler name should match class name');
	}

  /** Test virtual methods */
  @isTest
  static void testVirtualMethods() {
    TriggerHandler h = new TriggerHandler();
    h.beforeInsert();
    h.beforeUpdate();
    h.beforeDelete();
    h.afterInsert();
    h.afterUpdate();
    h.afterDelete();
    h.afterUndelete();
  }

  /* testing utilities */

  /** Sets last method call to null */
  private static void resetTest() {
    lastMethodCalled = null;
  }

  /** Sets context to 'before insert' */
  private static void beforeInsertMode() {
    handler.setTriggerContext('before insert', true);
  }

  /** Sets context to 'before update' */
  private static void beforeUpdateMode() {
    handler.setTriggerContext('before update', true);
  }

  /** Sets context to 'before delete' */
  private static void beforeDeleteMode() {
    handler.setTriggerContext('before delete', true);
  }

  /** Sets context to 'after insert' */
  private static void afterInsertMode() {
    handler.setTriggerContext('after insert', true);
  }

  /** Sets context to 'after update' */
  private static void afterUpdateMode() {
    handler.setTriggerContext('after update', true);
  }

  /** Sets context to 'after delete' */
  private static void afterDeleteMode() {
    handler.setTriggerContext('after delete', true);
  }

  /** Sets context to 'after undelete' */
  private static void afterUndeleteMode() {
    handler.setTriggerContext('after undelete', true);
  }

  /** Test implementation of the TriggerHandler */
  private class TestHandler extends TriggerHandler {

    /** Context test */
    public override void beforeInsert() {
      TriggerHandler_Test.lastMethodCalled = 'beforeInsert';
    }

    /** Context test */
    public override void  beforeUpdate() {
      TriggerHandler_Test.lastMethodCalled = 'beforeUpdate';
    }

    /** Context test */
    public override void beforeDelete() {
      TriggerHandler_Test.lastMethodCalled = 'beforeDelete';
    }

    /** Context test */
    public override void afterInsert() {
      TriggerHandler_Test.lastMethodCalled = 'afterInsert';
    }

    /** Context test */
    public override void afterUpdate() {
      TriggerHandler_Test.lastMethodCalled = 'afterUpdate';
    }

    /** Context test */
    public override void afterDelete() {
      TriggerHandler_Test.lastMethodCalled = 'afterDelete';
    }

    /** Context test */
    public override void afterUndelete() {
      TriggerHandler_Test.lastMethodCalled = 'afterUndelete';
    }
  }
}