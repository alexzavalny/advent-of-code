// OPEN GPT rewrote it for me. Just for curiosity and for 
function solution(nums, coef = 1, cycles = 1) {
  let items = nums.map((el, ndx) => ({ ndx, val: el * coef }));

  for (let i = 0; i < cycles; i++) {
    for (let ndx = 0; ndx < nums.length; ndx++) {
      let before = items.findIndex(el => el.ndx === ndx);
      let item = items.splice(before, 1)[0];
      let after = (before + item.val) % items.length;
      if (after < 0) after += items.length;
      items.splice(after, 0, item);
    }
  }

  let zeroNdx = items.findIndex(el => el.val === 0);
  let coords = [1000, 2000, 3000];
  return coords.reduce((sum, coord) => {
    return sum + items[(zeroNdx + coord) % nums.length].val;
  }, 0);
}

const numbers = require('fs').readFileSync('input1.txt', 'utf-8').split('\n').map(Number);
console.time("code");
console.log(`Part1: ${solution(numbers)}`);
console.log(`Part2: ${solution(numbers, 811589153, 10)}`);
console.timeEnd("code");
