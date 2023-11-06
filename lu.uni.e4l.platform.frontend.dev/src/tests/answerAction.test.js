import { selectPossibleAnswer } from '../js/action/answerAction';

test('selectPossibleAnswer should return the correct action object', () => {
  const possibleAnswerId = 1;
  const variable = 'exampleVariable';

  const action = selectPossibleAnswer(possibleAnswerId, variable);

  expect(action.type).toBe('SELECT_ANSWER');
  expect(action.payload).toEqual({ possibleAnswerId, variable });
});
